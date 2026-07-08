local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local LoadingIndicator = require(script.Parent.LoadingIndicator)
local List = Foundation.List
local View = Foundation.View
local InputSize = Foundation.Enums.InputSize
local SubagentTaskStatus = CreatorAgentChat.SubagentTaskStatus

local function createTrailingIndicator(t1: {[any]: any}, s1: string) -- line: 36
	-- upvalues: SubagentTaskStatus (copy), React (copy), View (copy), LoadingIndicator (copy)
	if t1.status == nil or t1.status == SubagentTaskStatus.Pending then
		return nil
	end

	return React.createElement(View, {
		tag = "auto-xy"
	}, {
		Indicator = React.createElement(LoadingIndicator, {
			status = t1.status,
			testId = `{ s1 }-loading-indicator`
		})
	})
end
local function TodoList(t2: {[any]: any}) -- line: 51
	-- upvalues: React (copy), List (copy), createTrailingIndicator (copy), InputSize (copy)
	local v15 = t2.testId or "subagent-status-list"
	local t3 = {}

	for v17, v18 in t2.items do
		local v19 = v18.testId or `{ v15 }-item-{ v17 }`

		t3[`Item{ v17 }`] = React.createElement(List.Item, {
			LayoutOrder = v17,
			description = v18.description,
			testId = v19,
			title = v18.title,
			trailing = createTrailingIndicator(v18, v19)
		})
	end

	return React.createElement(List.Root, {
		hasDivider = false,
		LayoutOrder = t2.layoutOrder,
		isContained = {
			isContained = false,
			hasMargin = false
		},
		size = InputSize.Medium,
		testId = v15
	}, t3)
end

return React.memo(TodoList)
