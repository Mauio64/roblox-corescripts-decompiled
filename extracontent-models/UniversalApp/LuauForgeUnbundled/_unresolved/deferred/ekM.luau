local AppStorageService = game:GetService("AppStorageService")

local module = require("@luauforge/deferred/eku")

return {
	isShown = function(p2)
		local success, item = pcall(AppStorageService.GetItem, AppStorageService, p2)
		return success and item == module.APP_STORAGE_VALUE
	end,
	markShown = function(p2)
		pcall(function()
			AppStorageService:SetItem(p2, module.APP_STORAGE_VALUE)
			AppStorageService:Flush()
		end)
	end
}
