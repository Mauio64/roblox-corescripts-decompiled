local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ApiFetchIAPProducts = require(Modules.LuaApp.Thunks.ApiFetchIAPProducts)
local v4 = game:GetService("GuiService"):IsTenFootInterface()
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local RobuxPackage = require(script.Parent.RobuxPackage)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local GetFFlagLuaAppEnableNativeRobuxProducts = require(Modules.LuaApp.Flags.GetFFlagLuaAppEnableNativeRobuxProducts)
local GetFFlagUseEnablePremiumUserFeaturesAppPolicy = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagUseEnablePremiumUserFeaturesAppPolicy

return function(p1, p2) -- line: 13
	-- upvalues: v4 (copy), IsVRAppBuild (copy), GetFFlagUseEnablePremiumUserFeaturesAppPolicy (copy), RobuxPackage (copy), RetrievalStatus (copy), GetFFlagLuaAppEnableNativeRobuxProducts (copy), ApiFetchIAPProducts (copy)
	local LocalUserId = p1.LocalUserId
	local v13 = not v4 and (not IsVRAppBuild() and (p1.Users[LocalUserId] and p1.Users[LocalUserId].membership == Enum.MembershipType.Premium))

	if GetFFlagUseEnablePremiumUserFeaturesAppPolicy() then
		v13 = p2.enablePremiumUserFeatures ~= nil and (p2.enablePremiumUserFeatures and (p1.Users[LocalUserId] and p1.Users[LocalUserId].membership == Enum.MembershipType.Premium))
	end

	local v14 = if not v13 then p1.IAPProducts.Robux else p1.IAPProducts.PremiumRobux
	local v15 = RobuxPackage.formatIapProducts(v14)
	local Done = RetrievalStatus.Done

	if GetFFlagLuaAppEnableNativeRobuxProducts() then
		if p1.NativeRobuxProducts.Products ~= nil then
			v15 = RobuxPackage.formatNativeRobuxProducts(p1.NativeRobuxProducts.Products)
		end

		Done = p1.NativeRobuxProducts.FetchingStatus
	end

	return {
		screenSize = p1.ScreenSize,
		iapPurchase = p1.NativePurchase,
		userId = LocalUserId,
		isPremium = v13,
		robuxBalance = p1.UserRobux[LocalUserId],
		robuxPackages = v15,
		iapProductsFetchingStatus = ApiFetchIAPProducts.GetFetchingStatus(p1),
		nativeProductsFetchingStatus = Done
	}
end
