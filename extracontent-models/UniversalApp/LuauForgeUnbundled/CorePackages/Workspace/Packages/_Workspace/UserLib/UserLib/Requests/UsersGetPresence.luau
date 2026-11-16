local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/Http").Url

return function(callback, items)
	local v5 = {}

	for k, item in pairs(items) do
		local v6 = tonumber(item)

		if v6 then
			table.insert(v5, v6)
		end
	end

	local jsonEncode = HttpService:JSONEncode({ userIds = v5 })

	return callback(string.format("%s/presence/users", url.PRESENCE_URL), "POST", {
		postBody = jsonEncode
	})
end
