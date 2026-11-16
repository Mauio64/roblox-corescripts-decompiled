local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")

local module = require("@luauforge/bundled/fpP")
local fStringApisCdnUrl = require("@luauforge/bundled/fpR").FStringApisCdnUrl
local fStringAXUnifiedAutocompleteVariant = require("@luauforge/bundled/fpS").FStringAXUnifiedAutocompleteVariant

return function(callback, p2)
	local v5 = string.format("%sunified-autocomplete-service/v2/%s/suggest", fStringApisCdnUrl, "avatar")

	local v6 = module(LocalizationService.RobloxLocaleId)

	local v7 = "?prefix=" .. HttpService:UrlEncode(p2) .. "&locale=" .. HttpService:UrlEncode(v6)

	if fStringAXUnifiedAutocompleteVariant ~= "" then
		v7 ..= "&variant=" .. HttpService:UrlEncode(fStringAXUnifiedAutocompleteVariant)
	end

	return callback(v5 .. v7, "GET", { timeout = 5000 })
end
