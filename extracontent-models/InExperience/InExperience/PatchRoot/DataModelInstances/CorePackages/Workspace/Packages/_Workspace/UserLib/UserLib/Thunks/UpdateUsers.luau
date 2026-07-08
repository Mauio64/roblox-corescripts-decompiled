local UserLib = script:FindFirstAncestor("UserLib")
local UserLibParent = UserLib.Parent
local User = require(UserLib.Models.User)
local AddUsers = require(UserLib.Actions.AddUsers)
local SetFriendCount = require(UserLibParent.LegacyFriendsRodux).Actions.SetFriendCount

return function(p1) -- line: 9
	-- upvalues: User (copy), AddUsers (copy), SetFriendCount (copy)
	return function(p2) -- line: 10
		-- upvalues: p1 (copy), User (copy), AddUsers (copy), SetFriendCount (copy)
		local n1 = 0
		local t1 = {}

		for _, v in pairs(p1) do
			local v12 = false
			local id = v.id
			local isFriend = v.isFriend
			local n2 = 0

			assert(typeof(isFriend) == "boolean", "Expected isFriend to be a string")

			local v16 = p2:getState().Users[id]

			if v16 then
				if not User.compare(v16, v) then
					v12 = true

					if isFriend ~= v16.isFriend then
						n2 = not isFriend and -1 or 1
					end
				end
			else
				v12 = true
				n2 = not isFriend and 0 or 1
			end

			if v12 then
				n1 += n2
				t1[id] = v
			end
		end

		if next(t1) then
			p2:dispatch(AddUsers(t1))
		end

		if n1 ~= 0 then
			local FriendCount = p2:getState().FriendCount

			p2:dispatch(SetFriendCount(FriendCount + n1))
		end
	end
end
