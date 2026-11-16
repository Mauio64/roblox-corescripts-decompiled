local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuyRobuxRouting/SharedFlags")

local EngineFeatures = require("@game/CorePackages/Workspace/Packages/_Index/BuyRobuxRouting/BuyRobuxRouting/EngineFeatures")

local function isSduiBuyRobuxSupported()
	return SharedFlags.FFlagSduiBuyRobuxHydration
		and SharedFlags.FFlagInitializeSduiForApp
		and EngineFeatures.isRobloxSubscriptionReadSupported()
		and EngineFeatures.isFirstTimePurchaseConsentStorageSupported()
end

return isSduiBuyRobuxSupported
