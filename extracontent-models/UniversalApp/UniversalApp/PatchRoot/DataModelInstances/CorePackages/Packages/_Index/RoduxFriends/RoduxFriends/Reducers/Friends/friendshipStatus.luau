local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)
local llama = require(parent2.llama)

local actions = parent.Actions
local FriendshipCreated = require(actions.FriendshipCreated)
local FriendshipDestroyed = require(actions.FriendshipDestroyed)
local FriendRequestCreated = require(actions.FriendRequestCreated)
local FriendRequestDeclined = require(actions.FriendRequestDeclined)

require(parent.roduxFriendsTypes)

local v = {}

local function mapFriendshipStatusToEnum(status: string) -- 2 equivalent calls inferred from this helper
	if status == "NotFriends" then
		return Enum.FriendStatus.NotFriend
	elseif status == "Friends" then
		return Enum.FriendStatus.Friend
	elseif status == "RequestSent" then
		return Enum.FriendStatus.FriendRequestSent
	elseif status == "RequestReceived" then
		return Enum.FriendStatus.FriendRequestReceived
	end

	return Enum.FriendStatus.Unknown
end

local function difference(items, items2)
	local v2 = {}

	for _, item in pairs(items) do
		v2[item] = true
	end

	for _, item in pairs(items2) do
		v2[item] = nil
	end

	local count = 0
	local result = {}

	for _, item in pairs(items) do
		if not v2[item] then
			continue
		end

		count += 1
		result[count] = item
	end

	return result
end

return function(p)
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(v, {
		[friendsNetworking.GetFriendshipStatus.Succeeded.name] = function(p2, p3)
			local v2 = {}

			for _, v3 in pairs(p3.responseBody.data) do
				local id = tostring(v3.id)
				v2[id] = mapFriendshipStatusToEnum(v3.status) -- inferred equivalent call
			end

			return llama.Dictionary.join(p2, v2)
		end,
		[friendsNetworking.GetExtendedFriendshipStatus.Succeeded.name] = function(p2, p3)
			local v2 = tostring(p3.ids[1])
			return llama.Dictionary.join(p2, {
				[v2] = mapFriendshipStatusToEnum(p3.responseBody.status) -- inferred equivalent call
			})
		end,
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p2, p3)
			local keys = llama.Dictionary.keys(llama.Dictionary.filter(p2, function(p4): boolean
				return p4 == Enum.FriendStatus.Friend
			end))

			local mapped = llama.List.map(llama.Dictionary.values(p3.responseBody.data), function(p4)
				return (tostring(p4.id))
			end)

			local v2 = difference(mapped, keys)
			local v3 = difference(keys, mapped)

			for _, v4 in pairs(v2) do
				p2 = llama.Dictionary.join(p2, { [v4] = Enum.FriendStatus.Friend })
			end

			for _, v4 in pairs(v3) do
				p2 = llama.Dictionary.join(p2, { [v4] = Enum.FriendStatus.Unknown })
			end

			return p2
		end,
		[friendsNetworking.UnfriendTargetUserId.Succeeded.name] = function(p2, p3)
			local users = tostring(p3.namedIds.users)
			return llama.Dictionary.join(p2, { [users] = Enum.FriendStatus.NotFriend })
		end,
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p2, p3)
			local v2 = tostring(p3.ids[1])
			return llama.Dictionary.join(p2, { [v2] = Enum.FriendStatus.Friend })
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(p2, p3)
			local ids = p3.ids
			local notFriends = {}

			for _, id in pairs(ids) do
				notFriends[tostring(id)] = Enum.FriendStatus.NotFriend
			end

			return llama.Dictionary.join(p2, notFriends)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p2, p3)
			local data = p3.responseBody.data
			local friendRequestReceivedsById = {}

			for _, v2 in pairs(data) do
				friendRequestReceivedsById[tostring(v2.id)] = Enum.FriendStatus.FriendRequestReceived
			end

			return llama.Dictionary.join(p2, friendRequestReceivedsById)
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
		[friendsNetworking.RequestFriendshipFromUserId.Succeeded.name] = function(p2, p3)
			local users = tostring(p3.namedIds.users)
			return llama.Dictionary.join(p2, { [users] = Enum.FriendStatus.FriendRequestSent })
		end,
		[friendsNetworking.RequestFriendshipFromContactId.Succeeded.name] = function(p2, p3)
			local contacts = tostring(p3.namedIds.contacts)
			return llama.Dictionary.join(p2, { [contacts] = Enum.FriendStatus.FriendRequestSent })
		end,
		[FriendshipDestroyed.name] = function(p2, p3)
			local userId1 = tostring(p3.payload.userId1)
			return llama.Dictionary.join(p2, { [userId1] = Enum.FriendStatus.NotFriend })
		end,
		[FriendshipCreated.name] = function(p2, p3)
			local userId1 = tostring(p3.payload.userId1)
			return llama.Dictionary.join(p2, { [userId1] = Enum.FriendStatus.Friend })
		end,
		[FriendRequestCreated.name] = function(p2, p3)
			local requesteeId = tostring(p3.requesteeId)
			return llama.Dictionary.join(p2, {
				[requesteeId] = Enum.FriendStatus.FriendRequestReceived
			})
		end,
		[FriendRequestDeclined.name] = function(p2, p3)
			local ids = p3.ids
			local notFriends = {}

			for _, id in pairs(ids) do
				notFriends[tostring(id)] = Enum.FriendStatus.NotFriend
			end

			return llama.Dictionary.join(p2, notFriends)
		end
	})
end
