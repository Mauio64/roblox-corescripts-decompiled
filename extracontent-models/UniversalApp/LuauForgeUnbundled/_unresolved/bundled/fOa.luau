require("@game/CorePackages/Workspace/Packages/Http")
local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(string.format("%susers/account-info", Url.API_URL), "GET", {
		maxRetryCount = 0
	})
end
