local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(script.Parent.FeedbackAction)

local IconButton = Foundation.IconButton
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconVariant = Foundation.Enums.IconVariant
local InputSize = Foundation.Enums.InputSize

local function UserFeedback(props)
	local testId = props.testId or "user-feedback"
	local onActivated = props.onActivated
	local selectedAction = props.selectedAction

	local children = {}

	for k, icon in props.icons do
		local icon2

		if selectedAction == icon.action then
			icon2 = { name = icon.iconName, variant = IconVariant.Filled }
		else
			icon2 = icon.iconName
		end

		local testId2 = icon.testId or `{testId}-{icon.iconName}`
		children[icon.testId or `{icon.iconName}-{k}`] = React.createElement(IconButton, {
			LayoutOrder = k,
			icon = icon2,
			isDisabled = icon.isDisabled,
			onActivated = function()
				if selectedAction == icon.action and icon.allowRepeatedActivation ~= true then
					return
				end

				onActivated(icon)
			end,
			size = InputSize.Small,
			variant = ButtonVariant.Utility,
			testId = testId2
		})
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "row align-y-center size-full-0 auto-y padding-top-small",
			testId = testId
		},
		{
			Actions = React.createElement(
				View,
				{ LayoutOrder = 1, tag = "row wrap align-x-right align-y-center gap-small auto-xy" },
				children
			)
		}
	)
end

return UserFeedback
