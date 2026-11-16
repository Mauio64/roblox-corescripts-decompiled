local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Http").Url

return function(callback)
	return callback(string.format("%sv1/account-creation/metadata", url.AUTH_URL), "GET", {
		maxRetryCount = 0
	})
end
