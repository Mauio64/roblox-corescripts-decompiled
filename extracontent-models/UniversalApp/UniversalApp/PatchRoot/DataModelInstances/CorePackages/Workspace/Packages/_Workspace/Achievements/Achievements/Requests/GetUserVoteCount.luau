local Parent = script:FindFirstAncestor("Achievements").Parent
local Url = require(Parent.Http).Url

return function(p1) -- line: 18
	-- upvalues: Url (copy)
	return p1(string.format("%svoting-api/user/get-vote-count?targetType=Place", Url.APIS_URL), "GET")
end
