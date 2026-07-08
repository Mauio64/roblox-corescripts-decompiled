local AppChat = script:FindFirstAncestor("AppChat")
local populateUserWithState = require(AppChat.Users.populateUserWithState)
local isUserInConversation = require(script.Parent.isUserInConversation)

return function(p1, p2) -- line: 6
	-- upvalues: isUserInConversation (copy), populateUserWithState (copy)
	local Users = p1.Users
	local t1 = {}

	for _, v in pairs(Users) do
		if v.id ~= tostring(p1.LocalUserId) and v.isFriend and not isUserInConversation(v.id, p2) then
			local v10 = populateUserWithState(p1, v)

			t1[v.id] = v10
		end
	end

	return t1
end
