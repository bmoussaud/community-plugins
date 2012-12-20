package ext.deployit.community.plugin.apache.planning;

import java.util.List;
import java.util.Set;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.google.common.base.Function;
import com.google.common.base.Predicate;

import com.xebialabs.deployit.plugin.api.deployment.planning.PrePlanProcessor;
import com.xebialabs.deployit.plugin.api.deployment.specification.Delta;
import com.xebialabs.deployit.plugin.api.deployment.specification.DeltaSpecification;
import com.xebialabs.deployit.plugin.api.deployment.specification.Operation;
import com.xebialabs.deployit.plugin.api.flow.Step;
import com.xebialabs.deployit.plugin.api.reflect.Type;
import com.xebialabs.deployit.plugin.api.udm.Container;
import com.xebialabs.deployit.plugin.api.udm.Deployed;

import static com.google.common.collect.Iterables.filter;
import static com.google.common.collect.Iterables.transform;
import static com.google.common.collect.Lists.newArrayList;
import static com.google.common.collect.Sets.intersection;
import static com.google.common.collect.Sets.newHashSet;
import static java.lang.String.format;

public class AssociateTargetsContributor {

    private static final Logger LOGGER = LoggerFactory.getLogger(AssociateTargetsContributor.class);

    @PrePlanProcessor
    public List<Step> associateTargetsByTags(DeltaSpecification specification) {

        for (Deployed deployed : transform(filter(specification.getDeltas(), IS_CREATED_APACHE_WORKER_TYPE), TO_DEPLOYED)) {
            final Boolean associateTargetsByTags = deployed.getProperty("associateTargetsByTags");
            LOGGER.debug("associateTargetsByTags {}, targets {}", associateTargetsByTags, deployed.getProperty("targets"));
            if (associateTargetsByTags) {
                final Set<Container> members = specification.getDeployedApplication().getEnvironment().getMembers();
                final Set<String> deployableTags = deployed.getDeployable().getTags();
                final Set<Container> candidates = newHashSet(filter(members, new Predicate<Container>() {
                    @Override
                    public boolean apply(final Container container) {
                        return !intersection(container.getTags(), deployableTags).isEmpty();
                    }
                }));
                candidates.remove(deployed.getContainer());
                deployed.setProperty("targets", newArrayList(candidates));
            }
            final List<Container> targets = deployed.getProperty("targets");
            LOGGER.debug("'{}': associated targets='{}'", deployed.getId(), targets);
            if (targets.isEmpty()) {
                throw new RuntimeException(format("'targets' property for %s is empty, please associate with at least one target container.", deployed.getId()));
            }

        }
        return null;
    }

    final static Function<Delta, Deployed> TO_DEPLOYED = new Function<Delta, Deployed>() {
        @Override
        public Deployed apply(final Delta input) {
            return input.getDeployed();
        }
    };

    static final Predicate<Delta> IS_CREATED_APACHE_WORKER_TYPE = new Predicate<Delta>() {
        final Type APACHE_WORKER_TYPE = Type.valueOf("www.ApacheModJKWorkerSetting");

        @Override
        public boolean apply(final Delta delta) {
            final Deployed<?, ?> deployed = delta.getDeployed();
            return delta.getOperation() == Operation.CREATE && deployed.getType().instanceOf(APACHE_WORKER_TYPE);
        }
    };

}
