local AppStorageService = game:GetService("AppStorageService")

local v5 = {}

function v5.canUseAppStorage()
	return game:GetEngineFeature("RobloxPlusImpressionStorageKey")
end

function v5.getImpressionCount()
	if not v5.canUseAppStorage() then
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

function v5.incrementImpressionCount()
	if not v5.canUseAppStorage() then
		return
	end

	pcall(function()
		local v6 = v5.getImpressionCount() + 1
		AppStorageService:SetItem("RobloxPlusUpsellBannerUnifiedBuyModalImpressionCount", (tostring(v6)))
		AppStorageService:Flush()
	end)
end

return v5
