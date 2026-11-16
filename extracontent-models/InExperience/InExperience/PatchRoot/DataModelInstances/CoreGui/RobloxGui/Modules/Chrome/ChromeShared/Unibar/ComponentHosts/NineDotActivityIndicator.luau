local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local StatusIndicator = Foundation.StatusIndicator
local StatusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local View = Foundation.View

local function NineDotActivityIndicator(props)
	if props.visible and not props.hasNotificationBadge then
		return React.createElement(
			View,
			{
				Position = props.position,
				tag = "anchor-top-left auto-xy padding-xxsmall radius-circle bg-surface-0",
				testId = "nine-dot-activity-indicator"
			},
			{
				Indicator = React.createElement(StatusIndicator, {
					variant = StatusIndicatorVariant.Emphasis
				})
			}
		)
	end

	return nil
end

return NineDotActivityIndicator
