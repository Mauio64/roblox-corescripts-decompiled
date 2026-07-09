local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Url = require(Modules.LuaApp.Http.Url)
local GetFFlagLuaAppAutocompleteIXPConfig = require(Modules.LuaApp.Flags.GetFFlagLuaAppAutocompleteIXPConfig)

return function(p1, p2, t1: {[any]: any}?) -- line: 44
	-- upvalues: GetFFlagLuaAppAutocompleteIXPConfig (copy), Cryo (copy), HttpService (copy), Url (copy)
	local v11 = nil

	if GetFFlagLuaAppAutocompleteIXPConfig() then
		local v12 = t1 or {}
		local v13 = Cryo.Dictionary.join(v12, {
			autocompleteUseCDN = Cryo.None,
			autocompleteUseGetMethodCDN = Cryo.None,
			autocompletePreloadedCache = Cryo.None,
			isAvatarAutocompleteEnabled = Cryo.None
		})
		local json = HttpService:JSONEncode(v13)

		v11 = json == "[]" and "" or HttpService:UrlEncode(json)
	end

	local APIS_URL = Url.APIS_URL
	local v16 = HttpService:UrlEncode(p2)
	local v17 = string.format("%sgames-autocomplete/v1/get-suggestion/%s", APIS_URL, v16)
	local v18 = v17 .. ((v11 == nil or v11 == "") and "" or "?args=" .. v11)

	if string.len(v18) > 2000 then
		warn("AutocompleteGameGetSuggestion URL max length exceeded", v18)
		v18 = v17
	end

	return p1(v18, "GET", {
		timeout = 5000
	})
end
