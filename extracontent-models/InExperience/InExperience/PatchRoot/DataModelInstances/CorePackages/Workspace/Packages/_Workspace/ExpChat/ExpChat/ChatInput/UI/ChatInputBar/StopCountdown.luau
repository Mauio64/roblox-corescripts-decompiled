local Parent = script:FindFirstAncestor("ExpChat").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

local function StopCountdown(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.View, {
		tag = "auto-xy radius-circle",
		Visible = t1.Visible,
		LayoutOrder = t1.LayoutOrder,
		GroupTransparency = t1.transparencyValue
	}, {
		Progress = React.createElement(Foundation.Progress, {
			tag = "position-center-center anchor-center-center",
			ZIndex = 2,
			shape = Foundation.Enums.ProgressShape.Circle,
			size = Foundation.Enums.ProgressSize.Medium,
			value = t1.countdownProgress:map(function(n1: number) -- line: 28
				return math.clamp(n1, 0, 1) * 100
			end)
		}),
		Icon = React.createElement(Foundation.IconButton, {
			isCircular = true,
			icon = Foundation.Enums.IconName.StopSmall,
			size = Foundation.Enums.InputSize.Small,
			variant = Foundation.Enums.ButtonVariant.Utility,
			onActivated = t1.onActivated
		})
	})
end

return React.memo(StopCountdown)
