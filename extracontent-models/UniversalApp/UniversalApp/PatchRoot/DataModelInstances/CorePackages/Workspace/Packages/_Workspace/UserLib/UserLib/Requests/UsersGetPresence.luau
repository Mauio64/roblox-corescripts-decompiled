local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("UserLib").Parent
local Url = require(Parent.Http).Url

return function(p1, p2) -- line: 9
	-- upvalues: HttpService (copy), Url (copy)
	local t1 = {}

	for _, v in pairs(p2) do
		local num = tonumber(v)

		if num then
			table.insert(t1, num)
		end
	end

	local json = HttpService:JSONEncode({
		userIds = t1
	})

	return p1(string.format("%s/presence/users", Url.PRESENCE_URL), "POST", {
		postBody = json
	})
end
