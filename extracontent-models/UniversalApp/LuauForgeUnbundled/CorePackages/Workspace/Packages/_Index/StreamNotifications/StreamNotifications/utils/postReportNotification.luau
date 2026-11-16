local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Promise")

local HttpService = game:GetService("HttpService")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UrlBuilder").UrlBuilder.new({
	base = url.APIS_URL,
	path = "notifications/v1/report-notification"
})

return function(callback, p2)
	if p2 == nil or p2 == "" then
		return Promise.reject()
	end

	return callback(urlBuilder(), "POST", {
		postBody = HttpService:JSONEncode({ notificationId = p2 })
	}):andThen(function(p3)
		if p3.responseCode == 200 then
			return Promise.resolve()
		end

		return Promise.reject()
	end, function(p3)
		return Promise.reject()
	end)
end
