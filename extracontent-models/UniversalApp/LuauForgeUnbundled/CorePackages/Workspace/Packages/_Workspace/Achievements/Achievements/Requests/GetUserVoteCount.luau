local url = require("@game/CorePackages/Workspace/Packages/_Workspace/Achievements/Http").Url

return function(callback)
	return callback(string.format("%svoting-api/user/get-vote-count?targetType=Place", url.APIS_URL), "GET")
end
