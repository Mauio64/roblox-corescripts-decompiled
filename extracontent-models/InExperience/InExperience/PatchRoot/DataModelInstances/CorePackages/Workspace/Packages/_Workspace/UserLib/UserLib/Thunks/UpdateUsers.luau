local UserLib = script:FindFirstAncestor("UserLib")
local parent = UserLib.Parent

local User = require(UserLib.Models.User)
local AddUsers = require(UserLib.Actions.AddUsers)
local LegacyFriendsRodux = require(parent.LegacyFriendsRodux)
local SetFriendCount = LegacyFriendsRodux.Actions.SetFriendCount
local SharedFlags = require(parent.SharedFlags)
local FFlagRemoveUnusedFriendCountRoduxSlice = SharedFlags.FFlagRemoveUnusedFriendCountRoduxSlice

return function(items)
	return function(object)
		local total = 0
		local v = {}

		for _, item in pairs(items) do
			local flag = false
			local id = item.id
			local isFriend = item.isFriend
			local v2 = 0

			assert(typeof(isFriend) == "boolean", "Expected isFriend to be a string")

			local user = object:getState().Users[id]

			if user then
				if not User.compare(user, item) then
					flag = true

					if user.isFriend ~= isFriend then
						v2 = isFriend and 1 or -1
					end
				end
			else
				flag = true
				v2 = isFriend and 1 or 0
			end

			if not flag then
				continue
			end

			total += v2
			v[id] = item
		end

		if next(v) then
			object:dispatch(AddUsers(v))
		end

		if not FFlagRemoveUnusedFriendCountRoduxSlice and total ~= 0 then
			object:dispatch(SetFriendCount(object:getState().FriendCount + total))
		end
	end
end
