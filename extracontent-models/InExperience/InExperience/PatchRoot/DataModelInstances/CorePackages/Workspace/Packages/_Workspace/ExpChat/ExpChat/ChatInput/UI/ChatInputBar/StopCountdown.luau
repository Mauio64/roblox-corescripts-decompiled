local parent = script:FindFirstAncestor("ExpChat").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function StopCountdown(props)
	return React.createElement(
		Foundation.View,
		{
			tag = "auto-xy radius-circle",
			Visible = props.Visible,
			LayoutOrder = props.LayoutOrder,
			GroupTransparency = props.transparencyValue
		},
		{
			Progress = React.createElement(Foundation.Progress, {
				tag = "position-center-center anchor-center-center",
				shape = Foundation.Enums.ProgressShape.Circle,
				size = Foundation.Enums.ProgressSize.Medium,
				value = props.countdownProgress:map(function(value: number)
					return math.clamp(value, 0, 1) * 100
				end),
				ZIndex = 2
			}),
			Icon = React.createElement(Foundation.IconButton, {
				icon = Foundation.Enums.IconName.StopSmall,
				size = Foundation.Enums.InputSize.Small,
				variant = Foundation.Enums.ButtonVariant.Utility,
				isCircular = true,
				onActivated = props.onActivated
			})
		}
	)
end

return React.memo(StopCountdown)
