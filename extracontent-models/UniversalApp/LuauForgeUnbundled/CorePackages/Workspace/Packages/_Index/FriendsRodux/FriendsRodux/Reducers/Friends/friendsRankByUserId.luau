local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local v5 = {}

return function(p2)
	local friendsNetworking = p2.friendsNetworking

	return Rodux.createReducer(v5, {
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p3, data)
			if not (data.queryArgs and data.queryArgs.userSort) then
				return p3
			end

			local users = tostring(data.namedIds.users)
			local data2 = data.responseBody.data or {}

			local mapped = llama.Dictionary.map(data2, function(p4, p5)
				return p5, (tostring(p4.id))
			end)

			return llama.Dictionary.join(p3, { [users] = mapped })
		end
	})
end
