local HttpService = game:GetService("HttpService")
local parent = script:FindFirstAncestor("UserLib").Parent

local Http = require(parent.Http)
local Url = Http.Url

return function(callback, items)
	local userIds = {}

	for _, item in pairs(items) do
		local v = tonumber(item)

		if v then
			table.insert(userIds, v)
		end
	end

	local jsonEncode = HttpService:JSONEncode({ userIds = userIds })

	return callback(string.format("%s/presence/users", Url.PRESENCE_URL), "POST", {
		postBody = jsonEncode
	})
end
