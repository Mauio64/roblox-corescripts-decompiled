local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Promise")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UrlBuilder").UrlBuilder.new({
	base = url.NOTIFICATION_URL,
	path = "v2/stream-notifications/action/{notificationId}/{actionPath}"
})

return function(callback, p2, p3)
	if p2 == nil or p2 == "" or p3 == nil or p3 == "" then
		return Promise.reject()
	end

	return callback(urlBuilder({ notificationId = p2, actionPath = p3 }), "POST", {
		postBody = "{}"
	}):andThen(
		function(p4)
			if p4.responseCode == 200 then
				return Promise.resolve()
			end

			return Promise.reject()
		end,
		function(p4)
			return Promise.reject()
		end
	)
end
