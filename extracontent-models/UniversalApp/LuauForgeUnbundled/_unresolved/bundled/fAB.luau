local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local Foundation = require(CorePackages.Packages.Foundation)
local badgeVariant = Foundation.Enums.BadgeVariant
local badge = Foundation.Badge

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local fFlagEnableNonFlyoutUncheckedBadge = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableNonFlyoutUncheckedBadge

local function UncheckedBadge(p2)
	local v5

	if fFlagEnableNonFlyoutUncheckedBadge then
		v5 = useAppPolicy(function(p3)
			return p3.getShowUncheckedBadge()
		end)
	else
		v5 = false
	end

	local v6 = useLocalization({ Unchecked = "CommonUI.Features.Label.Unchecked" })

	if v5 then
		return React.createElement(badge, {
			text = v6.Unchecked,
			variant = badgeVariant.Neutral,
			LayoutOrder = p2.layoutOrder
		})
	end

	return nil
end

return React.memo(UncheckedBadge)
