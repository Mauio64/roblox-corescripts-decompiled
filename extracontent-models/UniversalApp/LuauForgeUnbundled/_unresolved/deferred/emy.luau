local AppStorageService = game:GetService("AppStorageService")

local engineFeature = game:GetEngineFeature("RegisterFAEUpsellBannerDismissedStorageKey")

return {
	isDismissed = function()
		if not engineFeature then
			return true
		end

		local success, result = pcall(function()
			return AppStorageService:GetItem("FAEUpsellBannerDismissed")
		end)

		return success and result == "true"
	end,
	markDismissed = function()
		if not engineFeature then
			return
		end

		pcall(function()
			AppStorageService:SetItem("FAEUpsellBannerDismissed", "true")
			AppStorageService:Flush()
		end)
	end
}
