local parent = script:FindFirstAncestor("StreamNotifications").Parent
local Promise = require(parent.Promise)

local HttpService = game:GetService("HttpService")
local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder.new({
	base = Url.APIS_URL,
	path = "notifications/v1/report-notification"
})

return function(callback, notificationId)
	if notificationId == nil or notificationId == "" then
		return Promise.reject()
	end

	return callback(urlBuilder(), "POST", {
		postBody = HttpService:JSONEncode({ notificationId = notificationId })
	}):andThen(function(p)
		if p.responseCode == 200 then
			return Promise.resolve()
		end

		return Promise.reject()
	end, function(_)
		return Promise.reject()
	end)
end
