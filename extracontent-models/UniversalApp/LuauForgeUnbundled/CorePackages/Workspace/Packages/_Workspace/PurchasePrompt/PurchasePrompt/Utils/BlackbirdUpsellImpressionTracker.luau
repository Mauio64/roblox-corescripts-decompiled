local defineFastInt = game:DefineFastInt("BlackbirdUpsellBannerMaxSessionImpressions", 50)

local MemStorageService = game:GetService("MemStorageService")

local v5 = {}

function v5.getImpressionCount()
	local success, result = pcall(function()
		return MemStorageService:GetItem("BlackbirdUpsellBannerImpressionCount")
	end)

	if success and result and result ~= "" then
		return tonumber(result) or 0
	end

	return 0
end

function v5.incrementImpressionCount()
	local impressionCount = v5.getImpressionCount()
	pcall(function()
		MemStorageService:SetItem("BlackbirdUpsellBannerImpressionCount", (tostring(impressionCount + 1)))
	end)
end

function v5.hasReachedMaxImpressions(): boolean
	local v6 = defineFastInt

	if v6 == 0 then
		return false
	end

	return v6 <= v5.getImpressionCount()
end

return v5
