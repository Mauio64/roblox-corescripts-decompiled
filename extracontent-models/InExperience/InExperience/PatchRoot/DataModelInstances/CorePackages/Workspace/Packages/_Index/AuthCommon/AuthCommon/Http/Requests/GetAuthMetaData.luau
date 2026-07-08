local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Url = require(Parent.Http).Url

return function(p1) -- line: 16
	-- upvalues: Url (copy)
	return p1(string.format("%sv2/metadata", Url.AUTH_URL), "GET")
end
