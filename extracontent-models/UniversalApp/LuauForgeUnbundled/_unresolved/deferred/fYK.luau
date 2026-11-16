local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local v5 = require("@luauforge/bundled/fsq").new({
	base = Url.APIS_URL,
	path = "asset-text-filter-settings/public/universe/{universeId}"
})

return function(callback, value)
	assert(type(value) == "string", "GetAssetTextFilterSettings request expects universeId to be a string")
	return callback(v5({ universeId = value }), "GET")
end
