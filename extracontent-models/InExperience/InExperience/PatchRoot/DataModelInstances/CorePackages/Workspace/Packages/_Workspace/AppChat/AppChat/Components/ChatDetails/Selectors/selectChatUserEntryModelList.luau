local AppChat = script:FindFirstAncestor("AppChat")
local populateUserWithState = require(AppChat.Users.populateUserWithState)
local Logger = require(script.Parent.Parent.Logger)

return function(p, items, p2)
	local users = p.Users

	local result = {}

	for k, item in pairs(items) do
		local user = users[item]
		local v

		if p2 then
			v = p2[k]
		end

		if user then
			local v2 = populateUserWithState(p, user, v)
			result[user.id] = v2
		else
			Logger:warning("user is required in selectChatUserEntryModelList")
		end
	end

	return result
end
