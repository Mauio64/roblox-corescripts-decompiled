local defineFastInt = game:DefineFastInt("BlackbirdUpsellBannerMaxSessionImpressions", 50)

local MemStorageService = game:GetService("MemStorageService")

local BlackbirdUpsellImpressionTracker = {}

function BlackbirdUpsellImpressionTracker.getImpressionCount()
	local success, result = pcall(function()
		return MemStorageService:GetItem("BlackbirdUpsellBannerImpressionCount")
	end)

	if success and result and result ~= "" then
		return tonumber(result) or 0
	end

	return 0
end

function BlackbirdUpsellImpressionTracker.incrementImpressionCount()
	local impressionCount = BlackbirdUpsellImpressionTracker.getImpressionCount()
	pcall(function()
		MemStorageService:SetItem("BlackbirdUpsellBannerImpressionCount", (tostring(impressionCount + 1)))
	end)
end

function BlackbirdUpsellImpressionTracker.hasReachedMaxImpressions(): boolean
	local v = defineFastInt

	return v ~= 0 and v <= BlackbirdUpsellImpressionTracker.getImpressionCount()
end

return BlackbirdUpsellImpressionTracker
