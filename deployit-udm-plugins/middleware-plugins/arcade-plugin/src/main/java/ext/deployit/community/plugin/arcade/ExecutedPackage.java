package ext.deployit.community.plugin.arcade;

import com.xebialabs.deployit.plugin.api.deployment.planning.Create;
import com.xebialabs.deployit.plugin.api.deployment.planning.DeploymentPlanningContext;
import com.xebialabs.deployit.plugin.api.deployment.planning.Destroy;
import com.xebialabs.deployit.plugin.api.deployment.planning.Modify;
import com.xebialabs.deployit.plugin.api.deployment.specification.Delta;
import com.xebialabs.deployit.plugin.api.udm.base.BaseDeployed;

import ext.deployit.community.plugin.arcade.step.ArcadeStep;

public class ExecutedPackage extends BaseDeployed<Package,AS400> {

    @Create
    @Modify
    public void update(DeploymentPlanningContext context, Delta delta) {
        context.addStep(new ArcadeStep(this));
    }

    @Destroy
    public void destroy(DeploymentPlanningContext context, Delta delta) {
        //do nothinng

    }

}
