local Parent = script:FindFirstAncestor("Achievements").Parent
local Url = require(Parent.Http).Url

return function(p1) -- line: 18
	-- upvalues: Url (copy)
	return p1(string.format("%sv1/xbox/get-login-consecutive-days", Url.AUTH_URL), "GET")
end
