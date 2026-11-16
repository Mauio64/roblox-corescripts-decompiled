local url = require("@game/CorePackages/Workspace/Packages/Http").Url

return function(callback)
	return callback(string.format("%s/messages/unread/count", url.PRIVATEMESSAGES_URL), "GET")
end
