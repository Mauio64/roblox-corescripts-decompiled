local Parent = script:FindFirstAncestor("AuthSignup").Parent
local Url = require(Parent.Http).Url

return function(p1) -- line: 5
	-- upvalues: Url (copy)
	return p1(string.format("%sv1/account-creation/metadata", Url.AUTH_URL), "GET", {
		maxRetryCount = 0
	})
end
