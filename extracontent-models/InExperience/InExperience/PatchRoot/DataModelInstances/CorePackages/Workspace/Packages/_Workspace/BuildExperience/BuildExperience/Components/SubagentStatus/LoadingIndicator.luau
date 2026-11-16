local parent = script:FindFirstAncestor("BuildExperience").Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Icon = Foundation.Icon
local Progress = Foundation.Progress
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ProgressShape = Foundation.Enums.ProgressShape
local ProgressSize = Foundation.Enums.ProgressSize

local SubagentTaskStatus = CreatorAgentChat.SubagentTaskStatus

local function LoadingIndicator(props)
	local groupTransparency = React.useBinding(0)
	local testId = props.testId or "subagent-status-loading-indicator"
	local layoutOrder = props.layoutOrder

	if props.status == SubagentTaskStatus.InProgress then
		return React.createElement(
			View,
			{
				LayoutOrder = layoutOrder,
				GroupTransparency = groupTransparency,
				tag = "auto-xy clip"
			},
			{
				Progress = React.createElement(Progress, {
					shape = ProgressShape.Circle,
					size = ProgressSize.Small,
					testId = `{testId}-loading`
				})
			}
		)
	end

	if props.status == SubagentTaskStatus.Done then
		return React.createElement(Icon, {
			LayoutOrder = layoutOrder,
			name = IconName.CircleCheck,
			size = IconSize.Small,
			tag = "auto-xy content-system-success",
			testId = `{testId}-check-icon`
		})
	end

	if props.status == SubagentTaskStatus.Deleted then
		return React.createElement(Icon, {
			LayoutOrder = layoutOrder,
			name = IconName.CircleSlash,
			size = IconSize.Small,
			tag = "auto-xy content-emphasis",
			testId = `{testId}-deleted-icon`
		})
	end

	if props.status == SubagentTaskStatus.Error then
		return React.createElement(Icon, {
			LayoutOrder = layoutOrder,
			name = IconName.TriangleExclamation,
			size = IconSize.Small,
			tag = "auto-xy content-system-alert",
			testId = `{testId}-error-icon`
		})
	end

	return nil
end

return React.memo(LoadingIndicator)
