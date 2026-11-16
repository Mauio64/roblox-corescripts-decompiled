local parent = script:FindFirstAncestor("StreamNotifications").Parent
local Promise = require(parent.Promise)

local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder.new({
	base = Url.NOTIFICATION_URL,
	path = "v2/stream-notifications/action/{notificationId}/{actionPath}"
})

return function(callback, notificationId, actionPath)
	if notificationId == nil or notificationId == "" or actionPath == nil or actionPath == "" then
		return Promise.reject()
	end

	return callback(urlBuilder({ notificationId = notificationId, actionPath = actionPath }), "POST", {
		postBody = "{}"
	}):andThen(
		function(p)
			if p.responseCode == 200 then
				return Promise.resolve()
			end

			return Promise.reject()
		end,
		function(_)
			return Promise.reject()
		end
	)
end
