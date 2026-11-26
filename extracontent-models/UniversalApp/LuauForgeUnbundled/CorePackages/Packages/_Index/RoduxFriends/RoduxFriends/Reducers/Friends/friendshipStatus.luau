local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dFk")

local RoduxNetworking = require(CorePackages.Packages.RoduxNetworking)

local config = require("@game/CorePackages/Workspace/Packages/NetworkingFriends").config({ roduxNetworking = RoduxNetworking.mock() })

return function(options, data)
	local v5 = options or {}

	if data.type == module.name then
		return (Cryo.Dictionary.join(v5, { [data.id] = data.status }))
	end

	if data.type == config.RequestFriendshipFromUserId.Succeeded.name then
		local users = tostring(data.namedIds.users)
		return Cryo.Dictionary.join(v5, {
			[users] = Enum.FriendStatus.FriendRequestSent
		})
	end

	if data.type == config.AcceptFriendRequestFromUserId.Succeeded.name then
		local v6 = tostring(data.ids[1])
		return Cryo.Dictionary.join(v5, { [v6] = Enum.FriendStatus.Friend })
	end

	if data.type == config.DeclineFriendRequestFromUserId.Succeeded.name then
		local notFriends = {}

		for k, id in data.ids do
			notFriends[tostring(id)] = Enum.FriendStatus.NotFriend
		end

		return Cryo.Dictionary.join(v5, notFriends)
	else
		if data.type ~= config.UnfriendTargetUserId.Succeeded.name then
			return v5
		end

		local users = tostring(data.namedIds.users)
		return Cryo.Dictionary.join(v5, { [users] = Enum.FriendStatus.NotFriend })
	end
end
