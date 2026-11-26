local AppStorageService = game:GetService("AppStorageService")

local localStorageKey = require("@luauforge/bundled/dFv").Enums.LocalStorageKey

local v5 = {}
v5.__index = v5

function v5.getWebLogin()
	return tonumber(AppStorageService:GetItem(localStorageKey.WebLogin)) or 0
end

return v5
