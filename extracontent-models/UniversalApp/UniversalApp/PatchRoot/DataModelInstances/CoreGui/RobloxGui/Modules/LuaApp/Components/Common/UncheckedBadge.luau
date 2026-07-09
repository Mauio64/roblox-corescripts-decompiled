local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local BadgeVariant = Foundation.Enums.BadgeVariant
local Badge = Foundation.Badge
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local FFlagEnableNonFlyoutUncheckedBadge = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableNonFlyoutUncheckedBadge

local function UncheckedBadge(t1: {[any]: any}) -- line: 22
	-- upvalues: FFlagEnableNonFlyoutUncheckedBadge (copy), useAppPolicy (copy), useLocalization (copy), React (copy), Badge (copy), BadgeVariant (copy)
	local v11 = not not FFlagEnableNonFlyoutUncheckedBadge and useAppPolicy(function(p1) -- line: 24
		return p1.getShowUncheckedBadge()
	end)
	local v12 = useLocalization({
		Unchecked = "CommonUI.Features.Label.Unchecked"
	})

	if not v11 then
		return nil
	end

	return React.createElement(Badge, {
		text = v12.Unchecked,
		variant = BadgeVariant.Neutral,
		LayoutOrder = t1.layoutOrder
	})
end

return React.memo(UncheckedBadge)
