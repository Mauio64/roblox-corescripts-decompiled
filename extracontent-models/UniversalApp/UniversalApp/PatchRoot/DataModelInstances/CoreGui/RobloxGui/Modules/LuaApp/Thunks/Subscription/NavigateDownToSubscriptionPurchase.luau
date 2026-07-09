local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AppPage = require(Modules.LuaApp.AppPage)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)

require(Modules.LuaApp.Models.SubscriptionApi.SubscriptionProductInfoModel)

local EdpStoreAnalytics = require(CorePackages.Workspace.Packages.EdpStoreAnalytics)
local Constants = EdpStoreAnalytics.Constants
local GetFFlagEnableEdpStoreClickLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreClickLogging)
local GetFFlagEnableDevSubsInRobux = require(Modules.LuaApp.Flags.GetFFlagEnableDevSubsInRobux)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v10 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands

return function(p1, s1: string, b1: boolean, s2: string?, b2: boolean?) -- line: 21
	-- upvalues: GetFFlagEnableEdpStoreClickLogging (copy), EdpStoreAnalytics (copy), Constants (copy), AppPage (copy), GetFFlagEnableDevSubsInRobux (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy)
	if GetFFlagEnableEdpStoreClickLogging() then
		EdpStoreAnalytics.EdpStoreAnalyticsLogger.logEvent(Constants.StoreEnums.ActionType.ItemClick, Constants.StoreEnums.ProductType.Subscriptions, Constants.StoreEnums.LocationType.Store, tonumber(p1.subscriptionProviderId), tonumber(p1.subscriptionTargetKey), (tostring(p1.subscriptionTargetKey)))
	end

	return function(p2) -- line: 38
		-- upvalues: AppPage (copy), p1 (copy), s1 (copy), b1 (copy), GetFFlagEnableDevSubsInRobux (copy), s2 (copy), b2 (copy), FFlagSignalsNavP3Dispatch (copy), v10 (copy), NavigateDown (copy)
		local t1 = {
			detail = "",
			name = AppPage.SubscriptionPurchase,
			extraProps = {
				subscriptionPurchaseProductInfo = p1,
				thumbnailString = s1,
				isSubScribed = b1,
				isSubscribed = GetFFlagEnableDevSubsInRobux() and b1,
				creatorName = s2,
				creatorVerified = b2
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v10.down(v10.fromLegacyPage(t1))

			return
		end

		p2:dispatch(NavigateDown(t1))
	end
end
