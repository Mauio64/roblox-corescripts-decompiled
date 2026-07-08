local Parent = script:FindFirstAncestor("StreamNotifications").Parent
local Promise = require(Parent.Promise)
local HttpService = game:GetService("HttpService")
local Url = require(Parent.Http).Url
local v5 = require(Parent.UrlBuilder).UrlBuilder.new({
	path = "notifications/v1/report-notification",
	base = Url.APIS_URL
})

return function(p1, p2) -- line: 14
	-- upvalues: Promise (copy), v5 (copy), HttpService (copy)
	if p2 == nil or p2 == "" then
		return Promise.reject()
	end

	local v8 = v5()
	local t1 = {
		notificationId = p2
	}

	return p1(v8, "POST", {
		postBody = HttpService:JSONEncode(t1)
	}):andThen(function(p3) -- line: 28
		-- upvalues: Promise (copy)
		if p3.responseCode == 200 then
			return Promise.resolve()
		end

		return Promise.reject()
	end, function(_) -- line: 34
		-- upvalues: Promise (copy)
		return Promise.reject()
	end)
end
