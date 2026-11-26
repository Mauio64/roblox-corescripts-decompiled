require("@game/CorePackages/Workspace/Packages/Http")
local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(string.format("%susers/account-info", module.API_URL), "GET", {
		maxRetryCount = 0
	})
end
