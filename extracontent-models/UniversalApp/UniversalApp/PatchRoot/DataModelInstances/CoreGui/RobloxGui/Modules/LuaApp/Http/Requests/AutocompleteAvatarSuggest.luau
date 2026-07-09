local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local LocalizationContext = require(Modules.LuaApp.LocalizationContext)
local GetFStringApisCdnUrl = require(Modules.LuaApp.Flags.GetFStringApisCdnUrl)

return function(p1, p2) -- line: 20
	-- upvalues: GetFStringApisCdnUrl (copy), LocalizationService (copy), LocalizationContext (copy), HttpService (copy)
	local v8 = GetFStringApisCdnUrl()
	local v9 = string.format("%sautocomplete-avatar/v2/suggest", v8)
	local v10 = nil
	local RobloxLocaleId = LocalizationService.RobloxLocaleId

	if RobloxLocaleId ~= nil then
		v10 = LocalizationContext.getBaseLanguage(RobloxLocaleId)
	end

	if v10 == nil then
		v10 = "en"
	elseif v10 ~= "en" then
		v10 ..= ",en"
	end

	return p1(v9 .. "?limit=10&prefix=" .. HttpService:UrlEncode(p2) .. "&lang=" .. HttpService:UrlEncode(v10), "GET", {
		timeout = 5000
	})
end
