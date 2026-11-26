local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local icon = Foundation.Icon
local progress = Foundation.Progress
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local progressShape = Foundation.Enums.ProgressShape
local progressSize = Foundation.Enums.ProgressSize

local subagentTaskStatus = CreatorAgentChat.SubagentTaskStatus

local function LoadingIndicator(props)
	local v5 = React.useBinding(0)
	local testId = props.testId or "subagent-status-loading-indicator"
	local layoutOrder = props.layoutOrder

	if props.status == subagentTaskStatus.InProgress then
		return React.createElement(
			view,
			{ LayoutOrder = layoutOrder, GroupTransparency = v5, tag = "auto-xy clip" },
			{
				Progress = React.createElement(progress, {
					shape = progressShape.Circle,
					size = progressSize.Small,
					testId = `{testId}-loading`
				})
			}
		)
	end

	if props.status == subagentTaskStatus.Done then
		return React.createElement(icon, {
			LayoutOrder = layoutOrder,
			name = iconName.CircleCheck,
			size = iconSize.Small,
			tag = "auto-xy content-system-success",
			testId = `{testId}-check-icon`
		})
	end

	if props.status == subagentTaskStatus.Deleted then
		return React.createElement(icon, {
			LayoutOrder = layoutOrder,
			name = iconName.CircleSlash,
			size = iconSize.Small,
			tag = "auto-xy content-emphasis",
			testId = `{testId}-deleted-icon`
		})
	end

	if props.status == subagentTaskStatus.Error then
		return React.createElement(icon, {
			LayoutOrder = layoutOrder,
			name = iconName.TriangleExclamation,
			size = iconSize.Small,
			tag = "auto-xy content-system-alert",
			testId = `{testId}-error-icon`
		})
	end

	return nil
end

return React.memo(LoadingIndicator)
