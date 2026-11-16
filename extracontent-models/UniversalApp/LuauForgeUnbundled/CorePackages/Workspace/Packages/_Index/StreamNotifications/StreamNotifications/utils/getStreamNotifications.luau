local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Promise")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UrlBuilder").UrlBuilder.new({
	base = url.NOTIFICATION_URL,
	path = "v2/stream-notifications/get-recent",
	query = { maxRows = "{maxRows}", startIndex = "{startIndex}" }
})

return function(callback, value, value2)
	return callback(urlBuilder({
		maxRows = value or 10,
		startIndex = value2 or 0
	}), "GET"):andThen(function(p2)
		local responseBody = p2.responseBody or nil

		if p2.responseCode == 200 and responseBody ~= nil then
			return Promise.resolve(responseBody)
		end

		return Promise.reject()
	end, function(p2)
		return Promise.reject(p2)
	end)
end
