local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local iconSize = Foundation.Enums.IconSize
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/BuilderIcons")

local fFlagEnableFlyoutUncheckedBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags").FFlagEnableFlyoutUncheckedBadge

local function ChevronSmallDownButton(p2)
	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = "position-center-right anchor-center-right auto-xy radius-circle bg-action-standard padding-xsmall",
		onActivated = p2.onActivated,
		testId = "--core-ui-flyout-switch-account-chevron",
		LayoutOrder = 0
	}

	local v6 = if fFlagEnableFlyoutUncheckedBadge then p2.layoutOrder else nil
	v5.LayoutOrder = v6
	return createElement(view, v5, {
		Icon = React.createElement(Foundation.Icon, {
			tag = "position-center-center anchor-center-center auto-xy content-emphasis",
			name = BuilderIcons.Icon.ChevronSmallDown,
			size = iconSize.Medium
		})
	})
end

return ChevronSmallDownButton
