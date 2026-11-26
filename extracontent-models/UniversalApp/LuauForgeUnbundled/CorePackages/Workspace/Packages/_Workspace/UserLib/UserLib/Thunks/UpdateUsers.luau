local User = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Models/User")
local AddUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/UserLib/Actions/AddUsers")
local setFriendCount = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/LegacyFriendsRodux").Actions.SetFriendCount
local fFlagRemoveUnusedFriendCountRoduxSlice = require("@game/CorePackages/Workspace/Packages/_Workspace/UserLib/SharedFlags").FFlagRemoveUnusedFriendCountRoduxSlice

return function(items)
	return function(object)
		local total = 0
		local v5 = {}

		for k, item in pairs(items) do
			local flag = false
			local id = item.id
			local isFriend = item.isFriend
			local v6 = 0

			assert(typeof(isFriend) == "boolean", "Expected isFriend to be a string")

			local user = object:getState().Users[id]

			if user then
				if not User.compare(user, item) then
					flag = true

					if user.isFriend ~= isFriend then
						v6 = isFriend and 1 or -1
					end
				end
			else
				flag = true
				v6 = isFriend and 1 or 0
			end

			if not flag then
				continue
			end

			total += v6
			v5[id] = item
		end

		if next(v5) then
			object:dispatch(AddUsers(v5))
		end

		if not fFlagRemoveUnusedFriendCountRoduxSlice and total ~= 0 then
			object:dispatch(setFriendCount(object:getState().FriendCount + total))
		end
	end
end
