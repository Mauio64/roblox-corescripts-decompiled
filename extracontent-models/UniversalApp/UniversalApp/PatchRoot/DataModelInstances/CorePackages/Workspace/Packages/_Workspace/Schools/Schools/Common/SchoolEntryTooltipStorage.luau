local AppStorageService = game:GetService("AppStorageService")
local Schools = script:FindFirstAncestor("Schools")
local Constants = require(Schools.Common.Constants)

return {
	isShown = function(s1: string) -- line: 13
		-- upvalues: AppStorageService (copy), Constants (copy)
		local ok, result = pcall(AppStorageService.GetItem, AppStorageService, s1)

		return ok and result == Constants.APP_STORAGE_VALUE
	end,
	markShown = function(s2: string) -- line: 18
		-- upvalues: AppStorageService (copy), Constants (copy)
		pcall(function() -- line: 19
			-- upvalues: AppStorageService (copy), s2 (copy), Constants (copy)
			AppStorageService:SetItem(s2, Constants.APP_STORAGE_VALUE)
			AppStorageService:Flush()
		end)
	end
}
