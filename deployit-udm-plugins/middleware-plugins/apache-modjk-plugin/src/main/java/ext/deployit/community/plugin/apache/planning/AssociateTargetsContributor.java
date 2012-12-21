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
import com.xebialabs.deployit.plugin.api.reflect.PropertyDescriptor;
import com.xebialabs.deployit.plugin.api.reflect.Type;
import com.xebialabs.deployit.plugin.api.udm.Container;
import com.xebialabs.deployit.plugin.api.udm.Deployed;

import static com.google.common.collect.FluentIterable.from;
import static com.google.common.collect.Iterables.filter;
import static com.google.common.collect.Lists.newArrayList;
import static com.google.common.collect.Sets.intersection;
import static com.google.common.collect.Sets.newHashSet;
import static java.lang.String.format;

public class AssociateTargetsContributor {

    private static final String TARGET_PROPERTY_NAME = "targets";
    private static final Type SOURCE_TYPE = Type.valueOf("www.ApacheModJKWorkerSetting");

    private static final Logger LOGGER = LoggerFactory.getLogger(AssociateTargetsContributor.class);

    @PrePlanProcessor
    public List<Step> associateTargetsByTags(DeltaSpecification specification) {


        for (Deployed deployed : from(specification.getDeltas()).filter(IS_SOURCE_TYPE).transform(TO_DEPLOYED)) {
            final Boolean associateTargetsByTags = deployed.getProperty("associateTargetsByTags");
            final PropertyDescriptor propertyDescriptor = SOURCE_TYPE.getDescriptor().getPropertyDescriptor(TARGET_PROPERTY_NAME);
            final Type referencedType = propertyDescriptor.getReferencedType();
            LOGGER.debug("associateTargetsByTags {}, targets {}", associateTargetsByTags, deployed.getProperty(TARGET_PROPERTY_NAME));
            if (associateTargetsByTags) {
                final Set<Container> members = specification.getDeployedApplication().getEnvironment().getMembers();
                final Set<String> deployableTags = deployed.getDeployable().getTags();
                final Set<Container> candidates = newHashSet(filter(members, new Predicate<Container>() {
                    @Override
                    public boolean apply(final Container container) {
                        return container.getType().instanceOf(referencedType) && !intersection(container.getTags(), deployableTags).isEmpty();
                    }
                }));
                candidates.remove(deployed.getContainer());
                deployed.setProperty(TARGET_PROPERTY_NAME, newArrayList(candidates));
            }
            final List<Container> targets = deployed.getProperty(TARGET_PROPERTY_NAME);
            LOGGER.debug("'{}': associated targets='{}'", deployed.getId(), targets);
            if (targets.isEmpty()) {
                throw new RuntimeException(format("'targets' property for %s is empty, please associate with at least one target container.", deployed.getId()));
            }

        }
        return null;
    }

    final static Function<Delta, Deployed> TO_DEPLOYED = new Function<Delta, Deployed>() {
        @Override
        public Deployed apply(final Delta delta) {
            return delta.getDeployed();
        }
    };


    final static Predicate<Delta> IS_SOURCE_TYPE = new Predicate<Delta>() {
        @Override
        public boolean apply(final Delta delta) {
            return delta.getOperation() == Operation.CREATE && delta.getDeployed().getType().instanceOf(SOURCE_TYPE);
        }
    };

}
