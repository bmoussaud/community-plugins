package ext.deployit.community.plugin.restarter.planning;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import com.google.common.base.Function;
import com.google.common.base.Predicate;
import com.google.common.base.Predicates;
import com.google.common.collect.Sets;

import com.xebialabs.deployit.plugin.api.deployment.planning.Contributor;
import com.xebialabs.deployit.plugin.api.deployment.planning.DeploymentPlanningContext;
import com.xebialabs.deployit.plugin.api.deployment.specification.Delta;
import com.xebialabs.deployit.plugin.api.deployment.specification.Deltas;
import com.xebialabs.deployit.plugin.api.deployment.specification.Operation;
import com.xebialabs.deployit.plugin.api.udm.Deployable;
import com.xebialabs.deployit.plugin.api.udm.Deployed;
import com.xebialabs.deployit.plugin.generic.ci.BaseGenericContainer;
import com.xebialabs.deployit.plugin.generic.ci.Container;
import com.xebialabs.deployit.plugin.generic.ci.NestedContainer;
import com.xebialabs.deployit.plugin.generic.container.LifeCycleContributor;
import com.xebialabs.deployit.plugin.generic.deployed.AbstractDeployed;
import com.xebialabs.deployit.plugin.generic.deployed.ProcessedTemplate;

import static com.google.common.base.Strings.nullToEmpty;
import static com.google.common.collect.Iterables.filter;
import static com.google.common.collect.Iterables.transform;
import static com.google.common.collect.Lists.newArrayList;
import static java.lang.String.format;

public class RestarterContributor {

    private static final Predicate<Delta> IS_NOOP_OPERATION = new Predicate<Delta>() {
        @Override
        public boolean apply(final Delta input) {
            return input.getOperation().equals(Operation.NOOP);
        }
    };
    public static final Function<Delta, BaseGenericContainer> DELTA_TO_GENERIC_CONTAINER = new Function<Delta, BaseGenericContainer>() {
        @Override
        public BaseGenericContainer apply(final Delta input) {
            Deployed deployed = getDeployed(input);
            if (deployed instanceof AbstractDeployed) {
                AbstractDeployed abstractDeployed = (AbstractDeployed) deployed;
                return (BaseGenericContainer) abstractDeployed.getContainer();
            }
            return null;
        }

        private Deployed getDeployed(final Delta input) {
            return input.getOperation() == Operation.DESTROY ? input.getPrevious() : input.getDeployed();
        }
    };

    @Contributor
    public void restartContainers(Deltas deltas, DeploymentPlanningContext plan) {
        final List<Delta> deltaList = deltas.getDeltas();
        final Set<BaseGenericContainer> containers = gatherTargets(deltaList);
        if (containers.isEmpty())
            return;

        final Set<BaseGenericContainer> involvedContainers = Sets.newTreeSet(transform(
                filter(deltaList, Predicates.not(IS_NOOP_OPERATION)), DELTA_TO_GENERIC_CONTAINER));

        final ArrayList<Delta> newDeltas = newArrayList(filter(deltaList, IS_NOOP_OPERATION));
        for (BaseGenericContainer container : containers) {
            if (involvedContainers.contains(container))
                continue;
            newDeltas.add(new InnerDelta(container));
        }

        new LifeCycleContributor().restartContainers(new Deltas(newDeltas), plan);
    }

    public class InnerDelta implements Delta {

        private final BaseGenericContainer container;

        public InnerDelta(final BaseGenericContainer container) {
            this.container = container;
        }

        @Override
        public Operation getOperation() {
            return Operation.NOOP;
        }

        @Override
        public Deployed<?, ?> getPrevious() {
            return null;
        }

        @Override
        public Deployed<?, ?> getDeployed() {
            final ProcessedTemplate<Deployable> deployableProcessedTemplate = new ProcessedTemplate<Deployable>();
            deployableProcessedTemplate.setContainer(container);
            deployableProcessedTemplate.setRestartRequired(true);
            deployableProcessedTemplate.setRestartRequiredForNoop(true);
            return deployableProcessedTemplate;
        }
    }

    private static Set<BaseGenericContainer> gatherTargets(Iterable<Delta> operations) {
        final Set<BaseGenericContainer> targets = Sets.newTreeSet();
        for (Delta operation : operations) {
            addTarget(targets, operation.getOperation(), operation.getDeployed());
            addTarget(targets, operation.getOperation(), operation.getPrevious());
        }
        return targets;
    }

    private static void addTarget(Set<BaseGenericContainer> targets, Operation operation, Deployed<?, ?> deployed) {
        if (deployed == null) {
            return;
        }

        if (operation == Operation.NOOP) {
            return;
        }

        if (deployed instanceof AbstractDeployed) {
            List<Container> containers = deployed.getProperty("restartContainersRequiredForModification");
            if (containers == null || containers.isEmpty()) {
                return;
            }

            for (Container container : containers) {
                targets.add(getContainerToRestart(container));
            }
        }
    }

    private static BaseGenericContainer getContainerToRestart(com.xebialabs.deployit.plugin.api.udm.Container c) {
        if (c instanceof Container) {
            return (Container) c;
        } else if (c instanceof NestedContainer) {
            NestedContainer nc = (NestedContainer) c;
            if (!isNullOrEmpty(nc.getStartScript()) || !isNullOrEmpty(nc.getStopScript()) || !isNullOrEmpty(nc.getRestartScript())) {
                return nc;
            } else {
                return getContainerToRestart(nc.getParentContainer());
            }
        } else {
            throw new IllegalStateException(format("Container [%s] is not a generic (nested) container", c));
        }
    }

    private static boolean isNullOrEmpty(String s) {
        return nullToEmpty(s).trim().isEmpty();
    }


}
