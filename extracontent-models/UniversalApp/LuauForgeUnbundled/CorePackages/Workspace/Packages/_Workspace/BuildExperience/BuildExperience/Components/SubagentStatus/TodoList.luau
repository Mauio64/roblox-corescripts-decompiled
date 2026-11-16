local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local LoadingIndicator = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SubagentStatus/LoadingIndicator")

local list = Foundation.List
local view = Foundation.View

local inputSize = Foundation.Enums.InputSize

local subagentTaskStatus = CreatorAgentChat.SubagentTaskStatus

local function createTrailingIndicator(item, testId)
	if item.status == nil or item.status == subagentTaskStatus.Pending then
		return nil
	end

	return React.createElement(view, { tag = "auto-xy" }, {
		Indicator = React.createElement(LoadingIndicator, {
			status = item.status,
			testId = `{testId}-loading-indicator`
		})
	})
end

local function TodoList(props)
	local testId = props.testId or "subagent-status-list"
	local children = {}

	for k, item in props.items do
		local testId2 = item.testId or `{testId}-item-{k}`

		children[`Item{k}`] = React.createElement(list.Item, {
			LayoutOrder = k,
			description = item.description,
			testId = testId2,
			title = item.title,
			trailing = createTrailingIndicator(item, testId2)
		})
	end

	return React.createElement(list.Root, {
		LayoutOrder = props.layoutOrder,
		hasDivider = false,
		isContained = { isContained = false, hasMargin = false },
		size = inputSize.Medium,
		testId = testId
	}, children)
end

return React.memo(TodoList)
