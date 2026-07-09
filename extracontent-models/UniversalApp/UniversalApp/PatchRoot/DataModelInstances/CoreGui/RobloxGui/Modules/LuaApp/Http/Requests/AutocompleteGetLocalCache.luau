local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local LocalizationContext = require(Modules.LuaApp.LocalizationContext)
local GetFStringApisCdnUrl = require(Modules.LuaApp.Flags.GetFStringApisCdnUrl)
local t1 = {
	["zh-cn"] = "zh-hans",
	["zh-tw"] = "zh-hant"
}
local v6 = UrlBuilder.new({
	path = "/games-autocomplete/v1/request-local-cache/{variationId}",
	query = "{cursor}&{language}",
	base = GetFStringApisCdnUrl()
})

return function(p1, p2, p3, p4) -- line: 52
	-- upvalues: t1 (copy), LocalizationContext (copy), v6 (copy)
	local v11 = t1[p3] or (LocalizationContext.getBaseLanguage(p3 or "") or "")

	return p1(v6({
		variationId = p4 or 0,
		cursor = p2,
		language = v11
	}), "GET", {
		maxRetryCount = 0
	})
end
