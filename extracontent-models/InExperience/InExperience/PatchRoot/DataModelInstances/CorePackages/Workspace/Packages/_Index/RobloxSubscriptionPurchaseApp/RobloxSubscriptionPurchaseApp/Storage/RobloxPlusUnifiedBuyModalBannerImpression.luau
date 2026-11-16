local AppStorageService = game:GetService("AppStorageService")

local RobloxPlusUnifiedBuyModalBannerImpression = {}

function RobloxPlusUnifiedBuyModalBannerImpression.canUseAppStorage()
	return game:GetEngineFeature("RobloxPlusImpressionStorageKey")
end

function RobloxPlusUnifiedBuyModalBannerImpression.getImpressionCount()
	if not RobloxPlusUnifiedBuyModalBannerImpression.canUseAppStorage() then
		return 1e999
	end

	local success, result = pcall(function()
		return AppStorageService:GetItem("RobloxPlusUpsellBannerUnifiedBuyModalImpressionCount")
	end)

	if success and typeof(result) == "string" and result ~= "" then
		return tonumber(result) or 0
	end

	return 0
end

function RobloxPlusUnifiedBuyModalBannerImpression.incrementImpressionCount()
	if not RobloxPlusUnifiedBuyModalBannerImpression.canUseAppStorage() then
		return
	end

	pcall(function()
		AppStorageService:SetItem(
			"RobloxPlusUpsellBannerUnifiedBuyModalImpressionCount",
			(tostring(RobloxPlusUnifiedBuyModalBannerImpression.getImpressionCount() + 1))
		)
		AppStorageService:Flush()
	end)
end

return RobloxPlusUnifiedBuyModalBannerImpression
