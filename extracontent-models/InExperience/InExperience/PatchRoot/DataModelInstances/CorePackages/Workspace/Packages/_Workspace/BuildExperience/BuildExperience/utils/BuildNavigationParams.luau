local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.DataHydration.CreatorAgentChat)
require(BuildExperience.Chat.chatTypes)
local BuildNavigationParams = {}
BuildNavigationParams.BUILD_CHAT_SCREEN = "BuildChat"

function BuildNavigationParams.getTarget(p)
	return (p.getParam("target"))
end

function BuildNavigationParams.getSubagentTaskState(p)
	return (p.getParam("subagentTaskState"))
end

function BuildNavigationParams.getSubagentTaskGroupName(p)
	return (p.getParam("subagentTaskGroupName"))
end

function BuildNavigationParams.getInitialPrompt(p)
	return (p.getParam("initialPrompt"))
end

function BuildNavigationParams.getShouldDismissOnBack(p): boolean
	return p.getParam("dismissOnBack") == true
end

return BuildNavigationParams
