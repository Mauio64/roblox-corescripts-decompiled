local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local GetFFlagUADesktopPurchaseWarnings = require(Modules.LuaApp.Flags.GetFFlagUADesktopPurchaseWarnings)
local GetFFlagUseEnablePremiumUserFeaturesAppPolicy = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagUseEnablePremiumUserFeaturesAppPolicy

return function(p1, p2) -- line: 8
	-- upvalues: GetFFlagUADesktopPurchaseWarnings (copy), GetFFlagUseEnablePremiumUserFeaturesAppPolicy (copy)
	local LocalUserId = p1.LocalUserId
	local v8 = if not GetFFlagUADesktopPurchaseWarnings() then nil else p1.Users[LocalUserId] and p1.Users[LocalUserId].membership == Enum.MembershipType.Premium

	if GetFFlagUseEnablePremiumUserFeaturesAppPolicy() then
		v8 = if not GetFFlagUADesktopPurchaseWarnings() then nil else p2.enablePremiumUserFeatures and (p1.Users[LocalUserId] and p1.Users[LocalUserId].membership == Enum.MembershipType.Premium)
	end

	return {
		screenSize = p1.ScreenSize,
		iapPurchase = p1.NativePurchase,
		userId = LocalUserId,
		isPremium = v8
	}
end
