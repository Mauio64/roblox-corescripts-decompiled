local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local BuilderIcons = require(parent.BuilderIcons)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableFlyoutUncheckedBadge = SharedFlags.FFlagEnableFlyoutUncheckedBadge

local function ChevronSmallDownButton(p)
	local createElement = React.createElement
	local view = Foundation.View
	local v = {
		tag = "position-center-right anchor-center-right auto-xy radius-circle bg-action-standard padding-xsmall",
		onActivated = p.onActivated,
		testId = "--core-ui-flyout-switch-account-chevron",
		LayoutOrder = 0
	}
	local layoutOrder

	if FFlagEnableFlyoutUncheckedBadge then
		layoutOrder = p.layoutOrder
	end

	v.LayoutOrder = layoutOrder
	return createElement(view, v, {
		Icon = React.createElement(Foundation.Icon, {
			tag = "position-center-center anchor-center-center auto-xy content-emphasis",
			name = BuilderIcons.Icon.ChevronSmallDown,
			size = IconSize.Medium
		})
	})
end

return ChevronSmallDownButton
