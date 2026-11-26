local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")

return function(p2, value)
	local v5 = getDeepValue(p2, string.format("ChatAppReducer.Conversations.%s", value or ""))

	if not (v5 and v5.usersTyping and p2.Users) then
		return {}
	end

	local usersTyping = v5.usersTyping
	local users = p2.Users

	local result = {}

	for k, v6 in pairs(usersTyping) do
		if k ~= p2.LocalUserId and v6 then
			table.insert(result, users[k])
		end
	end

	return result
end
