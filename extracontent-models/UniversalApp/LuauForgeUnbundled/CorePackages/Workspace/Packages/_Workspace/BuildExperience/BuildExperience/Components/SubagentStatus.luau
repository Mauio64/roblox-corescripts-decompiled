local module = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SubagentStatus/AgentDetailsList")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SubagentStatus/AgentsList")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SubagentStatus/LoadingIndicator")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SubagentStatus/SubagentStatus")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SubagentStatus/TodoBottomSheet")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SubagentStatus/TodoList")

return {
	AgentDetailsList = module,
	AgentsList = module2,
	BottomSheet = module5,
	LoadingIndicator = module3,
	List = module6,
	Root = module4,
	SubagentStatus = module4,
	TodoBottomSheet = module5,
	TodoList = module6
}
