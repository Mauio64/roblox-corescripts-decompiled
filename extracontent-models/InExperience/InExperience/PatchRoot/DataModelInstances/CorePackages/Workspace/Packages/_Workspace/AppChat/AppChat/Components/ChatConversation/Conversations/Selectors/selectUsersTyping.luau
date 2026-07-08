local AppChat = script:FindFirstAncestor("AppChat")
local getDeepValue = require(AppChat.Utils.getDeepValue)

return function(p1, p2) -- line: 5
	-- upvalues: getDeepValue (copy)
	local v5 = getDeepValue(p1, string.format("ChatAppReducer.Conversations.%s", p2 or ""))

	if not v5 or (not v5.usersTyping or not p1.Users) then
		return {}
	end

	local usersTyping = v5.usersTyping
	local Users = p1.Users
	local t1 = {}

	for k, v in pairs(usersTyping) do
		if k ~= p1.LocalUserId and v then
			table.insert(t1, Users[k])
		end
	end

	return t1
end
