local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url

return function(callback)
	return callback(string.format("%sv2/metadata", url.AUTH_URL), "GET")
end
