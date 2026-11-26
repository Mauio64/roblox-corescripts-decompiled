local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/fxf")

local fStringApisCdnUrl = require("@game/CorePackages/Workspace/Packages/SharedFlags").FStringApisCdnUrl

return function(callback, p2)
	local v6 = string.format("%sautocomplete-avatar/v2/suggest", fStringApisCdnUrl)

	local robloxLocaleId = LocalizationService.RobloxLocaleId

	local v7 = if robloxLocaleId ~= nil then module.getBaseLanguage(robloxLocaleId) else nil

	if v7 == nil then
		v7 = "en"
	elseif v7 ~= "en" then
		v7 ..= ",en"
	end

	return callback(
		v6 .. "?limit=10&prefix=" .. HttpService:UrlEncode(p2) .. "&lang=" .. HttpService:UrlEncode(v7),
		"GET",
		{ timeout = 5000 }
	)
end
