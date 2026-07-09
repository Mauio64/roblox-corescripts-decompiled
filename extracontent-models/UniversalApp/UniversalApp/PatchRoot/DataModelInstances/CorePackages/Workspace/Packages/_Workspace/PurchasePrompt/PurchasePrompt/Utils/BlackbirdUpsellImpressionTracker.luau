local v1 = game:DefineFastInt("BlackbirdUpsellBannerMaxSessionImpressions", 50)
local MemStorageService = game:GetService("MemStorageService")
local t1 = {
	getImpressionCount = function() -- line: 10
		-- upvalues: MemStorageService (copy)
		local ok, result = pcall(function() -- line: 11
			-- upvalues: MemStorageService (copy)
			return MemStorageService:GetItem("BlackbirdUpsellBannerImpressionCount")
		end)

		if ok and (result and result ~= "") then
			return tonumber(result) or 0
		end

		return 0
	end
}

function t1.incrementImpressionCount() -- line: 20
	-- upvalues: t1 (copy), MemStorageService (copy)
	local v6 = t1.getImpressionCount()

	pcall(function() -- line: 22
		-- upvalues: MemStorageService (copy), v6 (copy)
		MemStorageService:SetItem("BlackbirdUpsellBannerImpressionCount", (tostring(v6 + 1)))
	end)
end
function t1.hasReachedMaxImpressions() -- line: 27
	-- upvalues: v1 (copy), t1 (copy)
	local v7 = v1

	if v7 == 0 then
		return false
	end

	return v7 <= t1.getImpressionCount()
end

return t1
