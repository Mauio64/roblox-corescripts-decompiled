local AppChat = script:FindFirstAncestor("AppChat")
local populateUserWithState = require(AppChat.Users.populateUserWithState)
local Logger = require(script.Parent.Parent.Logger)

return function(p1, p2, t1: {[any]: any}?) -- line: 5
	-- upvalues: populateUserWithState (copy), Logger (copy)
	local Users = p1.Users
	local t2 = {}

	for k, v in pairs(p2) do
		local v11 = Users[v]
		local v12 = if not t1 then nil else t1[k]

		if v11 then
			local v13 = populateUserWithState(p1, v11, v12)

			t2[v11.id] = v13
		else
			Logger:warning("user is required in selectChatUserEntryModelList")
		end
	end

	return t2
end
