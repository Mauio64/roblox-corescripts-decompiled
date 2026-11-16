local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url

return function(callback)
	return callback(string.format("%s/users/authenticated/app-launch-info", url.USERS_URL), "GET", {
		maxRetryCount = 0
	})
end
