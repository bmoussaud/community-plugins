package com.xebialabs.deployit.plugin.jbossdm.container;


import java.util.List;
import java.util.Map;
import java.util.Set;
import com.google.common.collect.Maps;
import com.google.common.collect.Sets;

import com.xebialabs.deployit.plugin.api.deployment.planning.Contributor;
import com.xebialabs.deployit.plugin.api.deployment.planning.DeploymentPlanningContext;
import com.xebialabs.deployit.plugin.api.deployment.specification.Delta;
import com.xebialabs.deployit.plugin.api.deployment.specification.Deltas;
import com.xebialabs.deployit.plugin.api.deployment.specification.Operation;
import com.xebialabs.deployit.plugin.api.flow.Step;
import com.xebialabs.deployit.plugin.api.udm.Deployed;
import com.xebialabs.deployit.plugin.generic.step.ScriptExecutionStep;
import com.xebialabs.deployit.plugin.generic.step.WaitStep;
import com.xebialabs.deployit.plugin.jbossdm.deployed.CliManagedDeployed;
import com.xebialabs.deployit.plugin.jbossdm.step.CliDeploymentStep;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Strings.isNullOrEmpty;
import static java.lang.String.format;

public class LifeCycleContributor {
    @Contributor
    public void restartContainers(Deltas deltas, DeploymentPlanningContext plan) {
        Set<StandaloneServer> containers = gatherTargets(deltas.getDeltas());
        for (StandaloneServer container : containers) {
            addStartAndStopSteps(plan, container);
        }
    }

    private static void addStartAndStopSteps(DeploymentPlanningContext plan, StandaloneServer target) {
        checkArgument(!isNullOrEmpty(target.<String>getProperty("startScript")), format("%s start script must be specified when no restart script defined.", target.getId()));
        checkArgument(!isNullOrEmpty(target.<String>getProperty("stopScript")), format("%s stop script must be specified when no restart script defined.", target.getId()));

        plan.addStep(newStep("Start", target, target.<String>getProperty("startScript"), target.<Integer>getProperty("startOrder")));
        addWaitStep(plan, "start", target, target.<Integer>getProperty("startWaitTime"), target.<Integer>getProperty("startOrder"));

        plan.addStep(newStep("Stop", target, target.<String>getProperty("stopScript"), target.<Integer>getProperty("stopOrder")));
        addWaitStep(plan, "stop", target, target.<Integer>getProperty("stopWaitTime"), target.<Integer>getProperty("stopOrder"));
    }

    private static Step newStep(String verb, StandaloneServer container, String script, int scriptOrder) {
        if (script.endsWith(".py")) {
            return createCliDeploymentStep(verb,container,script,scriptOrder);
        }
        else {
            return newScriptExecutionScriptStep(verb,container,script,scriptOrder);
        }
    }

    private static Step createCliDeploymentStep(String verb, StandaloneServer container, String script, int scriptOrder) {
        Map<String, Object> vars = Maps.newHashMap();
        vars.put("container", container);
        return new CliDeploymentStep(script, scriptOrder, vars, getDescription(verb, container), container);
    }

    private static Step newScriptExecutionScriptStep(String verb, StandaloneServer container, String script, int scriptOrder) {
        Map<String, Object> vars = Maps.newHashMap();
        vars.put("container", container);
        return new ScriptExecutionStep(scriptOrder, script, container, vars, getDescription(verb, container));
    }

    private static void addWaitStep(DeploymentPlanningContext plan, String action, StandaloneServer target, int waitTime, int scriptOrder) {
        if (waitTime > 0) {
            plan.addStep(new WaitStep(scriptOrder + 1, waitTime, target.getName(), action));
        }
    }

    private static Set<StandaloneServer> gatherTargets(List<Delta> operations) {
        final Set<StandaloneServer> targets = Sets.newTreeSet();
        for (Delta operation : operations) {
            addTarget(targets, operation.getOperation(), operation.getDeployed());
            addTarget(targets, operation.getOperation(), operation.getPrevious());
        }
        return targets;
    }

    private static void addTarget(Set<StandaloneServer> targets, Operation operation, Deployed<?, ?> deployed) {
        if (deployed == null) {
            return;
        }

        if (deployed instanceof CliManagedDeployed) {
            CliManagedDeployed cliManagedDeployed = (CliManagedDeployed) deployed;
            boolean restartRequired = cliManagedDeployed.getProperty("restartRequired");
            if (restartRequired && cliManagedDeployed.getContainer() instanceof StandaloneServer) {
                if (operation != Operation.NOOP || cliManagedDeployed.<Boolean>getProperty("restartRequiredForNoop")) {
                    targets.add((StandaloneServer) cliManagedDeployed.getContainer());
                }
            }
        }
    }

    private static String getDescription(String verb, StandaloneServer container) {
        return format("%s %s", verb, container.getName());
    }

}
