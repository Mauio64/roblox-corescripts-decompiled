local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthLocalStorageKeys = require(AuthCommon.Enums.AuthLocalStorageKeys)
local AppStorageService = game:GetService("AppStorageService")

local function isIosAuthServiceEnabled() -- line: 7
	-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
	return AppStorageService:GetItem(AuthLocalStorageKeys.IosAuthServiceEnabled) == "true"
end

return isIosAuthServiceEnabled
