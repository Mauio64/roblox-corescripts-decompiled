local AppStorageService = game:GetService("AppStorageService")
local EngineFeature = game:GetEngineFeature("RegisterFAEUpsellBannerDismissedStorageKey")

return {
	isDismissed = function() -- line: 7
		-- upvalues: EngineFeature (copy), AppStorageService (copy)
		if not EngineFeature then
			return true
		end

		local ok, result = pcall(function() -- line: 11
			-- upvalues: AppStorageService (copy)
			return AppStorageService:GetItem("FAEUpsellBannerDismissed")
		end)

		return ok and result == "true"
	end,
	markDismissed = function() -- line: 17
		-- upvalues: EngineFeature (copy), AppStorageService (copy)
		if not EngineFeature then
			return
		end

		pcall(function() -- line: 21
			-- upvalues: AppStorageService (copy)
			AppStorageService:SetItem("FAEUpsellBannerDismissed", "true")
			AppStorageService:Flush()
		end)
	end
}
