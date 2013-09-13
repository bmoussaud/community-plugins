package ext.deployit.community.plugin.arcade.step;

import com.xebialabs.deployit.plugin.api.flow.ExecutionContext;
import com.xebialabs.deployit.plugin.api.flow.Step;
import com.xebialabs.deployit.plugin.api.flow.StepExitCode;

import ext.deployit.community.plugin.arcade.ExecutedPackage;

public class ArcadeStep implements Step {

    public ArcadeStep(final ExecutedPackage executedPackage) {

    }

    @Override
    public int getOrder() {
        return 70;  //To change body of implemented methods use File | Settings | File Templates.
    }

    @Override
    public String getDescription() {
        return null;  //To change body of implemented methods use File | Settings | File Templates.
    }

    @Override
    public StepExitCode execute(final ExecutionContext executionContext) throws Exception {
        /// executed your code
        //if ok
        return StepExitCode.SUCCESS;
        // sinon
        //return StepExitCode.FAIL;

    }
}
