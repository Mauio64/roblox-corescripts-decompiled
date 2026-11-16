local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

local FriendshipCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendshipCreated")
local FriendshipDestroyed = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendshipDestroyed")
local FriendRequestCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendRequestCreated")
local FriendRequestDeclined = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendRequestDeclined")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local v5 = {}

local function mapFriendshipStatusToEnum(p2)
	if p2 == "NotFriends" then
		return Enum.FriendStatus.NotFriend
	elseif p2 == "Friends" then
		return Enum.FriendStatus.Friend
	elseif p2 == "RequestSent" then
		return Enum.FriendStatus.FriendRequestSent
	elseif p2 == "RequestReceived" then
		return Enum.FriendStatus.FriendRequestReceived
	end

	return Enum.FriendStatus.Unknown
end

local function difference(items, items2)
	local v6 = {}

	for k, item in pairs(items) do
		v6[item] = true
	end

	for k, item in pairs(items2) do
		v6[item] = nil
	end

	local count = 0
	local result = {}

	for k, item in pairs(items) do
		if not v6[item] then
			continue
		end

		count += 1
		result[count] = item
	end

	return result
end

return function(p2)
	local friendsNetworking = p2.friendsNetworking
	return Rodux.createReducer(v5, {
		[friendsNetworking.GetFriendshipStatus.Succeeded.name] = function(p3, p4)
			local v8 = {}

			for k, v9 in pairs(p4.responseBody.data) do
				local id = tostring(v9.id)
				local status = v9.status
				local v10

				if status == "NotFriends" then
					v10 = Enum.FriendStatus.NotFriend
				elseif status == "Friends" then
					v10 = Enum.FriendStatus.Friend
				elseif status == "RequestSent" then
					v10 = Enum.FriendStatus.FriendRequestSent
				elseif status == "RequestReceived" then
					v10 = Enum.FriendStatus.FriendRequestReceived
				else
					v10 = Enum.FriendStatus.Unknown
				end

				v8[id] = v10
			end

			return llama.Dictionary.join(p3, v8)
		end,
		[friendsNetworking.GetFriendshipStatuses.Succeeded.name] = function(p3, p4)
			local v8 = {}

			for k, v9 in pairs(p4.responseBody.data) do
				local id = tostring(v9.id)
				local status = v9.status
				local v10

				if status == "NotFriends" then
					v10 = Enum.FriendStatus.NotFriend
				elseif status == "Friends" then
					v10 = Enum.FriendStatus.Friend
				elseif status == "RequestSent" then
					v10 = Enum.FriendStatus.FriendRequestSent
				elseif status == "RequestReceived" then
					v10 = Enum.FriendStatus.FriendRequestReceived
				else
					v10 = Enum.FriendStatus.Unknown
				end

				v8[id] = v10
			end

			return llama.Dictionary.join(p3, v8)
		end,
		[friendsNetworking.GetExtendedFriendshipStatus.Succeeded.name] = function(p3, p4)
			local v8 = tostring(p4.ids[1])
			local join = llama.Dictionary.join
			local status = p4.responseBody.status
			local v10

			if status == "NotFriends" then
				v10 = Enum.FriendStatus.NotFriend
			elseif status == "Friends" then
				v10 = Enum.FriendStatus.Friend
			elseif status == "RequestSent" then
				v10 = Enum.FriendStatus.FriendRequestSent
			elseif status == "RequestReceived" then
				v10 = Enum.FriendStatus.FriendRequestReceived
			else
				v10 = Enum.FriendStatus.Unknown
			end

			return join(p3, { [v8] = v10 })
		end,
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p3, p4)
			local keys = llama.Dictionary.keys(llama.Dictionary.filter(p3, function(p5): boolean
				return p5 == Enum.FriendStatus.Friend
			end))

			local mapped = llama.List.map(llama.Dictionary.values(p4.responseBody.data), function(p5)
				return (tostring(p5.id))
			end)

			local v8 = difference(mapped, keys)
			local v9 = difference(keys, mapped)

			for k, v10 in pairs(v8) do
				p3 = llama.Dictionary.join(p3, { [v10] = Enum.FriendStatus.Friend })
			end

			for k, v10 in pairs(v9) do
				p3 = llama.Dictionary.join(p3, { [v10] = Enum.FriendStatus.Unknown })
			end

			return p3
		end,
		[friendsNetworking.UnfriendTargetUserId.Succeeded.name] = function(p3, p4)
			local users = tostring(p4.namedIds.users)
			return llama.Dictionary.join(p3, { [users] = Enum.FriendStatus.NotFriend })
		end,
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p3, p4)
			local v8 = tostring(p4.ids[1])
			return llama.Dictionary.join(p3, { [v8] = Enum.FriendStatus.Friend })
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(p3, p4)
			local ids = p4.ids
			local notFriends = {}

			for k, id in pairs(ids) do
				notFriends[tostring(id)] = Enum.FriendStatus.NotFriend
			end

			return llama.Dictionary.join(p3, notFriends)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p3, p4)
			local data = p4.responseBody.data
			local friendRequestReceivedsById = {}

			for k, v8 in pairs(data) do
				friendRequestReceivedsById[tostring(v8.id)] = Enum.FriendStatus.FriendRequestReceived
			end

			return llama.Dictionary.join(p3, friendRequestReceivedsById)
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function(items)
			local notFriends = {}

			for k, item in pairs(items) do
				if item == Enum.FriendStatus.FriendRequestReceived then
					notFriends[tostring(k)] = Enum.FriendStatus.NotFriend
				end
			end

			return llama.Dictionary.join(items, notFriends)
		end,
		[friendsNetworking.RequestFriendshipFromUserId.Succeeded.name] = function(p3, p4)
			local users = tostring(p4.namedIds.users)
			return llama.Dictionary.join(p3, {
				[users] = Enum.FriendStatus.FriendRequestSent
			})
		end,
		[friendsNetworking.RequestFriendshipFromContactId.Succeeded.name] = function(p3, p4)
			local contacts = tostring(p4.namedIds.contacts)
			return llama.Dictionary.join(p3, {
				[contacts] = Enum.FriendStatus.FriendRequestSent
			})
		end,
		[FriendshipDestroyed.name] = function(p3, p4)
			local userId1 = tostring(p4.payload.userId1)
			return llama.Dictionary.join(p3, {
				[userId1] = Enum.FriendStatus.NotFriend
			})
		end,
		[FriendshipCreated.name] = function(p3, p4)
			local userId1 = tostring(p4.payload.userId1)
			return llama.Dictionary.join(p3, { [userId1] = Enum.FriendStatus.Friend })
		end,
		[FriendRequestCreated.name] = function(p3, p4)
			local requesteeId = tostring(p4.requesteeId)
			return llama.Dictionary.join(p3, {
				[requesteeId] = Enum.FriendStatus.FriendRequestReceived
			})
		end,
		[FriendRequestDeclined.name] = function(p3, p4)
			local ids = p4.ids
			local notFriends = {}

			for k, id in pairs(ids) do
				notFriends[tostring(id)] = Enum.FriendStatus.NotFriend
			end

			return llama.Dictionary.join(p3, notFriends)
		end
	})
end
