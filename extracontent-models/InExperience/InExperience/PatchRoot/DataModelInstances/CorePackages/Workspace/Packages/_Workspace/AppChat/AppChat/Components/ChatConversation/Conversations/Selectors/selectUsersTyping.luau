local AppChat = script:FindFirstAncestor("AppChat")

local getDeepValue = require(AppChat.Utils.getDeepValue)

return function(p, value)
	local deepValue = getDeepValue(p, string.format("ChatAppReducer.Conversations.%s", value or ""))

	if not (deepValue and deepValue.usersTyping and p.Users) then
		return {}
	end

	local usersTyping = deepValue.usersTyping
	local users = p.Users

	local result = {}

	for k, v in pairs(usersTyping) do
		if k ~= p.LocalUserId and v then
			table.insert(result, users[k])
		end
	end

	return result
end
