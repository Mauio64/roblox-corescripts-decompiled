local Parent = script:FindFirstAncestor("StreamNotifications").Parent
local Promise = require(Parent.Promise)
local Url = require(Parent.Http).Url
local v4 = require(Parent.UrlBuilder).UrlBuilder.new({
	path = "v2/stream-notifications/clear-unread",
	base = Url.NOTIFICATION_URL
})

return function(p1) -- line: 13
	-- upvalues: v4 (copy), Promise (copy)
	return p1(v4(), "POST", {
		postBody = "{}"
	}):andThen(function(p2) -- line: 16
		-- upvalues: Promise (copy)
		if p2.responseCode == 200 then
			return Promise.resolve()
		end

		return Promise.reject()
	end, function(p3) -- line: 22
		-- upvalues: Promise (copy)
		return Promise.reject(p3)
	end)
end
