local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local IconSize = Foundation.Enums.IconSize
local BuilderIcons = require(Parent.BuilderIcons)
local FFlagEnableFlyoutUncheckedBadge = require(Parent.SharedFlags).FFlagEnableFlyoutUncheckedBadge

local function ChevronSmallDownButton(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), Foundation (copy), FFlagEnableFlyoutUncheckedBadge (copy), BuilderIcons (copy), IconSize (copy)
	return React.createElement(Foundation.View, {
		tag = "position-center-right anchor-center-right auto-xy radius-circle bg-action-standard padding-xsmall",
		onActivated = t1.onActivated,
		LayoutOrder = if not FFlagEnableFlyoutUncheckedBadge then nil else t1.layoutOrder
	}, {
		Icon = React.createElement(Foundation.Icon, {
			tag = "position-center-center anchor-center-center auto-xy content-emphasis",
			name = BuilderIcons.Icon.ChevronSmallDown,
			size = IconSize.Medium
		})
	})
end

return ChevronSmallDownButton
