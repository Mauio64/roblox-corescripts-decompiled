local parent = script:FindFirstAncestor("StreamNotifications").Parent
local Promise = require(parent.Promise)

local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder.new({
	base = Url.NOTIFICATION_URL,
	path = "v2/stream-notifications/get-recent",
	query = { maxRows = "{maxRows}", startIndex = "{startIndex}" }
})

return function(callback, value: number?, value2: number?)
	return callback(urlBuilder({
		maxRows = value or 10,
		startIndex = value2 or 0
	}), "GET"):andThen(function(p)
		local responseBody = p.responseBody or nil

		if p.responseCode == 200 and responseBody ~= nil then
			return Promise.resolve(responseBody)
		end

		return Promise.reject()
	end, function(p)
		return Promise.reject(p)
	end)
end
