local AppStorageService = game:GetService("AppStorageService")
local t1 = {
	canUseAppStorage = function() -- line: 16
		return game:GetEngineFeature("RobloxPlusImpressionStorageKey")
	end
}

function t1.getImpressionCount() -- line: 20
	-- upvalues: t1 (copy), AppStorageService (copy)
	if not t1.canUseAppStorage() then
		return 1e999
	end

	local ok, result = pcall(function() -- line: 24
		-- upvalues: AppStorageService (copy)
		return AppStorageService:GetItem("RobloxPlusUpsellBannerUnifiedBuyModalImpressionCount")
	end)

	if ok and typeof(result) == "string" and result ~= "" then
		return tonumber(result) or 0
	end

	return 0
end
function t1.incrementImpressionCount() -- line: 33
	-- upvalues: t1 (copy), AppStorageService (copy)
	if not t1.canUseAppStorage() then
		return
	end

	pcall(function() -- line: 37
		-- upvalues: t1 (copy), AppStorageService (copy)
		local v5 = t1.getImpressionCount() + 1

		AppStorageService:SetItem("RobloxPlusUpsellBannerUnifiedBuyModalImpressionCount", (tostring(v5)))
		AppStorageService:Flush()
	end)
end

return t1
