local parent = script:FindFirstAncestor("AuthCommon").Parent
local Http = require(parent.Http)
local Url = Http.Url

return function(callback)
	return callback(string.format("%s/users/authenticated/app-launch-info", Url.USERS_URL), "GET", {
		maxRetryCount = 0
	})
end
