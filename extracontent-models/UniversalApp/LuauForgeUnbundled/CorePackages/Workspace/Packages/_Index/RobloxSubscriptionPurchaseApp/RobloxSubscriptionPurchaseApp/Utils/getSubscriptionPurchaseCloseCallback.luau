local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local engineFeature = game:GetEngineFeature("ReadHasRobloxSubscriptionLua")

local engineFeature2 = game:GetEngineFeature("EnablePromptSignalRobloxSubscriptionPurchaseFinished")

local function getSubscriptionPurchaseCloseCallback()
	local v5

	if engineFeature then
		local success, result = pcall(function()
			return Players.LocalPlayer.HasRobloxSubscription
		end)
		v5 = success and result == true
	else
		v5 = false
	end

	if v5 or not engineFeature2 then
		return nil
	end

	return function()
		MarketplaceService:signalPromptRobloxSubscriptionPurchaseFinished(" ", true)
	end
end

return getSubscriptionPurchaseCloseCallback
