local url = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Http").Url

return function(callback)
	return callback(string.format("%sv1/xbox/get-login-consecutive-days", url.AUTH_URL), "GET")
end
