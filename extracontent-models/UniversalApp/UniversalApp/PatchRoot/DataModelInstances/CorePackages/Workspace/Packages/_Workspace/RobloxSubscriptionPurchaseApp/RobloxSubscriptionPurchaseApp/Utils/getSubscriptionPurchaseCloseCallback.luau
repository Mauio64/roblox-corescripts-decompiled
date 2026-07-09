local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local EngineFeature = game:GetEngineFeature("ReadHasRobloxSubscriptionLua")
local EngineFeature2 = game:GetEngineFeature("EnablePromptSignalRobloxSubscriptionPurchaseFinished")

local function getSubscriptionPurchaseCloseCallback() -- line: 8
	-- upvalues: EngineFeature (copy), Players (copy), EngineFeature2 (copy), MarketplaceService (copy)
	local v6 = false

	if EngineFeature then
		local ok, result = pcall(function() -- line: 11
			-- upvalues: Players (copy)
			return Players.LocalPlayer.HasRobloxSubscription
		end)

		v6 = ok and result == true
	end

	if not v6 and EngineFeature2 then
		return function() -- line: 18
			-- upvalues: MarketplaceService (copy)
			MarketplaceService:signalPromptRobloxSubscriptionPurchaseFinished(" ", true)
		end
	end

	return nil
end

return getSubscriptionPurchaseCloseCallback
