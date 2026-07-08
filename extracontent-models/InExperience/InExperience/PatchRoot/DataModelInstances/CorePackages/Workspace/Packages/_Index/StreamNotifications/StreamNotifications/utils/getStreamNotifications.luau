local Parent = script:FindFirstAncestor("StreamNotifications").Parent
local Promise = require(Parent.Promise)
local Url = require(Parent.Http).Url
local v4 = require(Parent.UrlBuilder).UrlBuilder.new({
	path = "v2/stream-notifications/get-recent",
	base = Url.NOTIFICATION_URL,
	query = {
		maxRows = "{maxRows}",
		startIndex = "{startIndex}"
	}
})

return function(p1, n1: number?, n2: number?) -- line: 17
	-- upvalues: v4 (copy), Promise (copy)
	local v8 = n1 or 10
	local v9 = n2 or 0

	return p1(v4({
		maxRows = v8,
		startIndex = v9
	}), "GET"):andThen(function(p2) -- line: 26
		-- upvalues: Promise (copy)
		local v11 = p2.responseBody or nil

		if p2.responseCode == 200 and v11 ~= nil then
			return Promise.resolve(v11)
		end

		return Promise.reject()
	end, function(p3) -- line: 33
		-- upvalues: Promise (copy)
		return Promise.reject(p3)
	end)
end
