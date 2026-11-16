local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Promise")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UrlBuilder").UrlBuilder.new({
	base = url.NOTIFICATION_URL,
	path = "v2/stream-notifications/clear-unread"
})

return function(callback)
	return callback(urlBuilder(), "POST", { postBody = "{}" }):andThen(function(p2)
		if p2.responseCode == 200 then
			return Promise.resolve()
		end

		return Promise.reject()
	end, function(p2)
		return Promise.reject(p2)
	end)
end
