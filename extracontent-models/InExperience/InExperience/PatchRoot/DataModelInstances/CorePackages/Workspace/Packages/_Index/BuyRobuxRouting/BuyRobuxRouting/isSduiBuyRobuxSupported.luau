local BuyRobuxRouting = script:FindFirstAncestor("BuyRobuxRouting")
local parent = BuyRobuxRouting.Parent

local SharedFlags = require(parent.SharedFlags)

local EngineFeatures = require(BuyRobuxRouting.EngineFeatures)

local function isSduiBuyRobuxSupported()
	return SharedFlags.FFlagSduiBuyRobuxHydration
		and SharedFlags.FFlagInitializeSduiForApp
		and EngineFeatures.isRobloxSubscriptionReadSupported()
		and EngineFeatures.isFirstTimePurchaseConsentStorageSupported()
end

return isSduiBuyRobuxSupported
