local Parent = script:FindFirstAncestor("BuildExperience").Parent
local CreatorAgentChat = require(Parent.DataHydration.CreatorAgentChat)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Icon = Foundation.Icon
local Progress = Foundation.Progress
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ProgressShape = Foundation.Enums.ProgressShape
local ProgressSize = Foundation.Enums.ProgressSize
local SubagentTaskStatus = CreatorAgentChat.SubagentTaskStatus

local function LoadingIndicator(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), SubagentTaskStatus (copy), View (copy), Progress (copy), ProgressShape (copy), ProgressSize (copy), Icon (copy), IconName (copy), IconSize (copy)
	local v15 = React.useBinding(0)
	local v16 = t1.testId or "subagent-status-loading-indicator"
	local layoutOrder = t1.layoutOrder

	if t1.status == SubagentTaskStatus.InProgress then
		return React.createElement(View, {
			tag = "auto-xy clip",
			LayoutOrder = layoutOrder,
			GroupTransparency = v15
		}, {
			Progress = React.createElement(Progress, {
				shape = ProgressShape.Circle,
				size = ProgressSize.Small,
				testId = `{ v16 }-loading`
			})
		})
	end

	if t1.status == SubagentTaskStatus.Done then
		return React.createElement(Icon, {
			tag = "auto-xy content-system-success",
			LayoutOrder = layoutOrder,
			name = IconName.CircleCheck,
			size = IconSize.Small,
			testId = `{ v16 }-check-icon`
		})
	end

	if t1.status == SubagentTaskStatus.Deleted then
		return React.createElement(Icon, {
			tag = "auto-xy content-emphasis",
			LayoutOrder = layoutOrder,
			name = IconName.CircleSlash,
			size = IconSize.Small,
			testId = `{ v16 }-deleted-icon`
		})
	end

	if t1.status == SubagentTaskStatus.Error then
		return React.createElement(Icon, {
			tag = "auto-xy content-system-alert",
			LayoutOrder = layoutOrder,
			name = IconName.TriangleExclamation,
			size = IconSize.Small,
			testId = `{ v16 }-error-icon`
		})
	end

	return nil
end

return React.memo(LoadingIndicator)
