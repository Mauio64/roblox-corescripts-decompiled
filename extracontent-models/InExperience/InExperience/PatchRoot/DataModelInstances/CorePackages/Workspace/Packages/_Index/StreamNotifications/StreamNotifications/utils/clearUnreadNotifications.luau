local parent = script:FindFirstAncestor("StreamNotifications").Parent
local Promise = require(parent.Promise)

local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder.new({
	base = Url.NOTIFICATION_URL,
	path = "v2/stream-notifications/clear-unread"
})

return function(callback)
	return callback(urlBuilder(), "POST", { postBody = "{}" }):andThen(function(p)
		if p.responseCode == 200 then
			return Promise.resolve()
		end

		return Promise.reject()
	end, function(p)
		return Promise.reject(p)
	end)
end
