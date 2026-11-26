local AuthLocalStorageKeys = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/AuthLocalStorageKeys")
local AppStorageService = game:GetService("AppStorageService")

local function isIosAuthServiceEnabled(): boolean
	return AppStorageService:GetItem(AuthLocalStorageKeys.IosAuthServiceEnabled) == "true"
end

return isIosAuthServiceEnabled
