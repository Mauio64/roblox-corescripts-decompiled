local Parent = script:FindFirstAncestor("StreamNotifications").Parent
local Promise = require(Parent.Promise)
local Url = require(Parent.Http).Url
local v4 = require(Parent.UrlBuilder).UrlBuilder.new({
	path = "v2/stream-notifications/action/{notificationId}/{actionPath}",
	base = Url.NOTIFICATION_URL
})

return function(p1, p2, p3) -- line: 13
	-- upvalues: Promise (copy), v4 (copy)
	if p2 == nil or (p2 == "" or p3 == nil or p3 == "") then
		return Promise.reject()
	end

	return p1(v4({
		notificationId = p2,
		actionPath = p3
	}), "POST", {
		postBody = "{}"
	}):andThen(function(p4) -- line: 23
		-- upvalues: Promise (copy)
		if p4.responseCode == 200 then
			return Promise.resolve()
		end

		return Promise.reject()
	end, function(_) -- line: 29
		-- upvalues: Promise (copy)
		return Promise.reject()
	end)
end
