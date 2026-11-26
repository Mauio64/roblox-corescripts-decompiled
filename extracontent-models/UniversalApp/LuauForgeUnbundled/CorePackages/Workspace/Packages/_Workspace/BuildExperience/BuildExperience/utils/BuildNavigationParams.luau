require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")

return {
	BUILD_CHAT_SCREEN = "BuildChat",
	getTarget = function(p2)
		return p2.getParam("target")
	end,
	getSubagentTaskState = function(p2)
		return p2.getParam("subagentTaskState")
	end,
	getSubagentTaskGroupName = function(p2)
		return p2.getParam("subagentTaskGroupName")
	end,
	getInitialPrompt = function(p2)
		return p2.getParam("initialPrompt")
	end,
	getShouldDismissOnBack = function(p2): boolean
		return p2.getParam("dismissOnBack") == true
	end
}
