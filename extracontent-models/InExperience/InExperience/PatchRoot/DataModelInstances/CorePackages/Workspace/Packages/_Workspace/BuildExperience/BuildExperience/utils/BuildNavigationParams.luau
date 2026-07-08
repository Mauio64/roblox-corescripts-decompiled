local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent

require(BuildExperienceParent.DataHydration.CreatorAgentChat)
require(BuildExperience.Chat.chatTypes)

return {
	getTarget = function(p1) -- line: 15
		return (p1.getParam("target"))
	end,
	getSubagentTaskState = function(p2) -- line: 19
		return (p2.getParam("subagentTaskState"))
	end,
	getSubagentTaskGroupName = function(p3) -- line: 23
		return (p3.getParam("subagentTaskGroupName"))
	end
}
