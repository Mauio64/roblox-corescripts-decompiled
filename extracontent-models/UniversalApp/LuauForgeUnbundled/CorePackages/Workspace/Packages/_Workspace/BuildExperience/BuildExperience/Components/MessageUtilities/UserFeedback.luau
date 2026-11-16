local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MessageUtilities/FeedbackAction")

local iconButton = Foundation.IconButton
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconVariant = Foundation.Enums.IconVariant
local inputSize = Foundation.Enums.InputSize

local function UserFeedback(props)
	local testId = props.testId or "user-feedback"
	local onActivated = props.onActivated
	local selectedAction = props.selectedAction

	local children = {}

	for k, icon in props.icons do
		local v5

		if selectedAction == icon.action then
			v5 = { name = icon.iconName, variant = iconVariant.Filled }
		else
			v5 = icon.iconName
		end

		local testId2 = icon.testId or `{testId}-{icon.iconName}`
		children[icon.testId or `{icon.iconName}-{k}`] = React.createElement(iconButton, {
			LayoutOrder = k,
			icon = v5,
			isDisabled = icon.isDisabled,
			onActivated = function()
				if selectedAction == icon.action and icon.allowRepeatedActivation ~= true then
					return
				end

				onActivated(icon)
			end,
			size = inputSize.Small,
			variant = buttonVariant.Utility,
			testId = testId2
		})
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "row align-y-center size-full-0 auto-y padding-top-small",
			testId = testId
		},
		{
			Actions = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "row wrap align-x-right align-y-center gap-small auto-xy"
				},
				children
			)
		}
	)
end

return UserFeedback
