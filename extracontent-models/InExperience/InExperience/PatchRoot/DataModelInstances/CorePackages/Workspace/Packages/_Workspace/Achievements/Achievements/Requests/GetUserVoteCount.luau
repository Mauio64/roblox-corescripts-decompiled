local parent = script:FindFirstAncestor("Achievements").Parent

local Http = require(parent.Http)
local Url = Http.Url

return function(callback)
	return callback(string.format("%svoting-api/user/get-vote-count?targetType=Place", Url.APIS_URL), "GET")
end
