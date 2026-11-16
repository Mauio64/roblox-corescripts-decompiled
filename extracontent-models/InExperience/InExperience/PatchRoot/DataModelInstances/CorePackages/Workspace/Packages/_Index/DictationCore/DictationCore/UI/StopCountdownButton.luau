local parent = script:FindFirstAncestor("DictationCore").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local CountdownRing = require(script.Parent.CountdownRing)

local function StopCountdownButton(props)
	local countdownProgress = props.countdownProgress

	local createElement = React.createElement
	local view = Foundation.View
	local v = {
		tag = "auto-xy radius-circle",
		Visible = props.Visible,
		LayoutOrder = props.LayoutOrder,
		GroupTransparency = props.transparencyValue
	}
	local progress

	if countdownProgress ~= nil then
		progress = React.createElement(CountdownRing, { countdownProgress = countdownProgress })
	end

	return createElement(view, v, {
		Progress = progress,
		Icon = React.createElement(Foundation.IconButton, {
			icon = Foundation.Enums.IconName.StopSmall,
			size = Foundation.Enums.InputSize.Small,
			variant = Foundation.Enums.ButtonVariant.Utility,
			isCircular = true,
			onActivated = props.onActivated
		})
	})
end

return React.memo(StopCountdownButton)
