local module = require("@luauforge/deferred/gij")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local tenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface()
local module2 = require("@luauforge/deferred/gus")
local module3 = require("@luauforge/bundled/dxy")
local module4 = require("@luauforge/bundled/dwf")

local getFFlagUseEnablePremiumUserFeaturesAppPolicy = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagUseEnablePremiumUserFeaturesAppPolicy

return function(data, p2)
	local localUserId = data.LocalUserId

	local v5 = not (tenFootInterface or isVRAppBuild())
		and data.Users[localUserId]
		and data.Users[localUserId].membership == Enum.MembershipType.Premium

	if getFFlagUseEnablePremiumUserFeaturesAppPolicy() then
		if p2.enablePremiumUserFeatures == nil then
			v5 = false
		else
			v5 = p2.enablePremiumUserFeatures
				and data.Users[localUserId]
				and data.Users[localUserId].membership == Enum.MembershipType.Premium
		end
	end

	local v6 = if v5 then data.IAPProducts.PremiumRobux else data.IAPProducts.Robux
	local v7 = module2.formatIapProducts(v6)
	local v8 = module3.Done

	if module4() then
		if data.NativeRobuxProducts.Products ~= nil then
			v7 = module2.formatNativeRobuxProducts(data.NativeRobuxProducts.Products)
		end

		v8 = data.NativeRobuxProducts.FetchingStatus
	end

	return {
		screenSize = data.ScreenSize,
		iapPurchase = data.NativePurchase,
		userId = localUserId,
		isPremium = v5,
		robuxBalance = data.UserRobux[localUserId],
		robuxPackages = v7,
		iapProductsFetchingStatus = module.GetFetchingStatus(data),
		nativeProductsFetchingStatus = v8
	}
end
