local AppStorageService = game:GetService("AppStorageService")
local CorePackages = game:GetService("CorePackages")
local LocalStorageKey = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey
local t1 = {}

t1.__index = t1

function t1.getWebLogin() -- line: 8
	-- upvalues: AppStorageService (copy), LocalStorageKey (copy)
	return tonumber(AppStorageService:GetItem(LocalStorageKey.WebLogin)) or 0
end

return t1
