local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local view = Foundation.View
local statusIndicator = Foundation.StatusIndicator
local statusIndicatorVariant = Foundation.Enums.StatusIndicatorVariant
local useTokens = Foundation.Hooks.useTokens

local module = require("@luauforge/bundled/dHH")

local function MeTabBadgeIcon(props)
	local v5 = useTokens()
	local size_700 = v5.Size.Size_700
	local size_200 = v5.Size.Size_200

	local v6 = module()

	React.useEffect(function()
		if props.isChecked then
			v6.dismiss()
		end
	end, { props.isChecked, v6.dismiss })

	local v7 = if props.renderIcon then props.renderIcon(props.isChecked, props.controlState) else nil

	if v6.showBadge then
		return React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(size_700, size_700)
			},
			{
				Icon = v7,
				BadgeAnchor = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(size_200, size_200),
					Position = UDim2.fromScale(1, 0),
					AnchorPoint = Vector2.new(0.6, 0.35),
					ZIndex = 2
				}, {
					Ring = React.createElement(
						view,
						{
							Position = UDim2.fromScale(0.5, 0.5),
							AnchorPoint = Vector2.new(0.5, 0.5),
							tag = "auto-xy padding-xxsmall radius-circle bg-surface-0"
						},
						{
							Indicator = React.createElement(statusIndicator, {
								variant = statusIndicatorVariant.Emphasis
							})
						}
					)
				})
			}
		)
	end

	return v7
end

return React.memo(MeTabBadgeIcon)
