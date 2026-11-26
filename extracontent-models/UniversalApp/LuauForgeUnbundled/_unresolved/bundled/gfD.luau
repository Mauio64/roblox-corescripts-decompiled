local module = require("@luauforge/bundled/fzK")
local module2 = require("@luauforge/bundled/fxf")
local fStringApisCdnUrl = require("@game/CorePackages/Workspace/Packages/SharedFlags").FStringApisCdnUrl

local v5 = { ["zh-cn"] = "zh-hans", ["zh-tw"] = "zh-hant" }

local v6 = module.new({
	base = fStringApisCdnUrl,
	path = "/games-autocomplete/v1/request-local-cache/{variationId}",
	query = "{cursor}&{language}"
})

return function(callback, p2, value, value2)
	return callback(v6({
		variationId = value2 or 0,
		cursor = p2,
		language = v5[value] or module2.getBaseLanguage(value or "") or ""
	}), "GET", { maxRetryCount = 0 })
end
