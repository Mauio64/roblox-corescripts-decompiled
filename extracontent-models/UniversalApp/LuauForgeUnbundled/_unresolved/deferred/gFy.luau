local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/ehB")
require("@luauforge/bundled/gCI")
local module3 = require("@luauforge/deferred/gCJ")
local constants = module3.Constants

local module4 = require("@luauforge/deferred/gCM")
local module5 = require("@luauforge/deferred/gFz")

local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

return function(p2, p3, p4, p5, p6)
	if module4() then
		module3.EdpStoreAnalyticsLogger.logEvent(
			constants.StoreEnums.ActionType.ItemClick,
			constants.StoreEnums.ProductType.Subscriptions,
			constants.StoreEnums.LocationType.Store,
			tonumber(p2.subscriptionProviderId),
			tonumber(p2.subscriptionTargetKey),
			(tostring(p2.subscriptionTargetKey))
		)
	end

	return function(object)
		local v5 = {
			name = module.SubscriptionPurchase,
			detail = "",
			extraProps = {
				subscriptionPurchaseProductInfo = p2,
				thumbnailString = p3,
				isSubScribed = p4,
				isSubscribed = module5() and p4,
				creatorName = p5,
				creatorVerified = p6
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			object:dispatch(module2(v5))
		end
	end
end
