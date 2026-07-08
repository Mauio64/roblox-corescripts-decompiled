local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Url = require(Parent.Http).Url

return function(p1) -- line: 12
	-- upvalues: Url (copy)
	return p1(string.format("%s/users/authenticated/app-launch-info", Url.USERS_URL), "GET", {
		maxRetryCount = 0
	})
end
