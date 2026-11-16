local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")

local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/getDeepValue")
local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

local v5 = {}

return function(p2)
	local friendsNetworking = p2.friendsNetworking

	return Rodux.createReducer(v5, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p3, p4)
			local data = p4.responseBody.data
			return (llama.Dictionary.map(data, function(p5)
				return getDeepValue(p5, "friendRequest.originSourceType"), (tostring(p5.id))
			end))
		end
	})
end
