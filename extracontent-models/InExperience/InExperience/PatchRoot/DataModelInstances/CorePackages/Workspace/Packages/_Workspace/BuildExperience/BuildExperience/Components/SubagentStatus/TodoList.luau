local parent = script:FindFirstAncestor("BuildExperience").Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local LoadingIndicator = require(script.Parent.LoadingIndicator)

local List = Foundation.List
local View = Foundation.View

local InputSize = Foundation.Enums.InputSize

local SubagentTaskStatus = CreatorAgentChat.SubagentTaskStatus

local function createTrailingIndicator(item, testId: string)
	if item.status == nil or item.status == SubagentTaskStatus.Pending then
		return nil
	end

	return React.createElement(View, { tag = "auto-xy" }, {
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

		children[`Item{k}`] = React.createElement(List.Item, {
			LayoutOrder = k,
			description = item.description,
			testId = testId2,
			title = item.title,
			trailing = createTrailingIndicator(item, testId2)
		})
	end

	return React.createElement(List.Root, {
		LayoutOrder = props.layoutOrder,
		hasDivider = false,
		isContained = { isContained = false, hasMargin = false },
		size = InputSize.Medium,
		testId = testId
	}, children)
end

return React.memo(TodoList)
