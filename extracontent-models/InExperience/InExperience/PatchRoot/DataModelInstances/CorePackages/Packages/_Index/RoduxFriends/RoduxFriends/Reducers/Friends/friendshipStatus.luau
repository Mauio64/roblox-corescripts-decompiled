local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local llama = require(ParentParentParent.llama)
local Actions = ParentParent.Actions
local FriendshipCreated = require(Actions.FriendshipCreated)
local FriendshipDestroyed = require(Actions.FriendshipDestroyed)
local FriendRequestCreated = require(Actions.FriendRequestCreated)
local FriendRequestDeclined = require(Actions.FriendRequestDeclined)

require(ParentParent.roduxFriendsTypes)

local t1 = {}

local function mapFriendshipStatusToEnum(s1: string) -- line: 18
	if s1 == "NotFriends" then
		return Enum.FriendStatus.NotFriend
	end

	if s1 == "Friends" then
		return Enum.FriendStatus.Friend
	end

	if s1 == "RequestSent" then
		return Enum.FriendStatus.FriendRequestSent
	end

	if s1 == "RequestReceived" then
		return Enum.FriendStatus.FriendRequestReceived
	end

	return Enum.FriendStatus.Unknown
end
local function difference(t2: {[any]: any}, t3: {[any]: any}) -- line: 32
	local t4 = {}

	for _, v in pairs(t2) do
		t4[v] = true
	end

	for _, v in pairs(t3) do
		t4[v] = nil
	end

	local t5 = {}
	local n1 = 0

	for _, v in pairs(t2) do
		if t4[v] then
			n1 += 1
			t5[n1] = v
		end
	end

	return t5
end

return function(p1) -- line: 54
	-- upvalues: Rodux (copy), t1 (copy), llama (copy), difference (copy), FriendshipDestroyed (copy), FriendshipCreated (copy), FriendRequestCreated (copy), FriendRequestDeclined (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(t1, {
		[friendsNetworking.GetFriendshipStatus.Succeeded.name] = function(p2, p3) -- line: 58
			-- upvalues: llama (copy)
			local t6 = {}

			for _, v in pairs(p3.responseBody.data) do
				local str = tostring(v.id)
				local status = v.status

				t6[str] = if status ~= "NotFriends" then if status ~= "Friends" then if status ~= "RequestSent" then if status ~= "RequestReceived" then Enum.FriendStatus.Unknown else Enum.FriendStatus.FriendRequestReceived else Enum.FriendStatus.FriendRequestSent else Enum.FriendStatus.Friend else Enum.FriendStatus.NotFriend
			end

			return llama.Dictionary.join(p2, t6)
		end,
		[friendsNetworking.GetExtendedFriendshipStatus.Succeeded.name] = function(p4, p5) -- line: 66
			-- upvalues: llama (copy)
			local str = tostring(p5.ids[1])
			local join = llama.Dictionary.join
			local t7 = {}
			local status = p5.responseBody.status

			t7[str] = if status ~= "NotFriends" then if status ~= "Friends" then if status ~= "RequestSent" then if status ~= "RequestReceived" then Enum.FriendStatus.Unknown else Enum.FriendStatus.FriendRequestReceived else Enum.FriendStatus.FriendRequestSent else Enum.FriendStatus.Friend else Enum.FriendStatus.NotFriend

			return join(p4, t7)
		end,
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p6, p7) -- line: 71
			-- upvalues: llama (copy), difference (copy)
			local v42 = llama.Dictionary.keys(llama.Dictionary.filter(p6, function(p8) -- line: 72
				return p8 == Enum.FriendStatus.Friend
			end))
			local v43 = llama.List.map(llama.Dictionary.values(p7.responseBody.data), function(p9) -- line: 75
				return (tostring(p9.id))
			end)
			local v44 = difference(v43, v42)
			local v45 = difference(v42, v43)

			for _, v in pairs(v44) do
				p6 = llama.Dictionary.join(p6, {
					[v] = Enum.FriendStatus.Friend
				})
			end

			for _, v in pairs(v45) do
				p6 = llama.Dictionary.join(p6, {
					[v] = Enum.FriendStatus.Unknown
				})
			end

			return p6
		end,
		[friendsNetworking.UnfriendTargetUserId.Succeeded.name] = function(p10, p11) -- line: 94
			-- upvalues: llama (copy)
			local str = tostring(p11.namedIds.users)

			return llama.Dictionary.join(p10, {
				[str] = Enum.FriendStatus.NotFriend
			})
		end,
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p12, p13) -- line: 101
			-- upvalues: llama (copy)
			local str = tostring(p13.ids[1])

			return llama.Dictionary.join(p12, {
				[str] = Enum.FriendStatus.Friend
			})
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(p14, p15) -- line: 108
			-- upvalues: llama (copy)
			local ids = p15.ids
			local t8 = {}

			for _, v in pairs(ids) do
				t8[tostring(v)] = Enum.FriendStatus.NotFriend
			end

			return llama.Dictionary.join(p14, t8)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p16, p17) -- line: 117
			-- upvalues: llama (copy)
			local data = p17.responseBody.data
			local t9 = {}

			for _, v in pairs(data) do
				t9[tostring(v.id)] = Enum.FriendStatus.FriendRequestReceived
			end

			return llama.Dictionary.join(p16, t9)
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function(p18) -- line: 126
			-- upvalues: llama (copy)
			local t10 = {}

			for k, v in pairs(p18) do
				if v == Enum.FriendStatus.FriendRequestReceived then
					t10[tostring(k)] = Enum.FriendStatus.NotFriend
				end
			end

			return llama.Dictionary.join(p18, t10)
		end,
		[friendsNetworking.RequestFriendshipFromUserId.Succeeded.name] = function(p19, p20) -- line: 136
			-- upvalues: llama (copy)
			local str = tostring(p20.namedIds.users)

			return llama.Dictionary.join(p19, {
				[str] = Enum.FriendStatus.FriendRequestSent
			})
		end,
		[friendsNetworking.RequestFriendshipFromContactId.Succeeded.name] = function(p21, p22) -- line: 143
			-- upvalues: llama (copy)
			local str = tostring(p22.namedIds.contacts)

			return llama.Dictionary.join(p21, {
				[str] = Enum.FriendStatus.FriendRequestSent
			})
		end,
		[FriendshipDestroyed.name] = function(p23, p24) -- line: 150
			-- upvalues: llama (copy)
			local str = tostring(p24.payload.userId1)

			return llama.Dictionary.join(p23, {
				[str] = Enum.FriendStatus.NotFriend
			})
		end,
		[FriendshipCreated.name] = function(p25, p26) -- line: 157
			-- upvalues: llama (copy)
			local str = tostring(p26.payload.userId1)

			return llama.Dictionary.join(p25, {
				[str] = Enum.FriendStatus.Friend
			})
		end,
		[FriendRequestCreated.name] = function(p27, p28) -- line: 164
			-- upvalues: llama (copy)
			local str = tostring(p28.requesteeId)

			return llama.Dictionary.join(p27, {
				[str] = Enum.FriendStatus.FriendRequestReceived
			})
		end,
		[FriendRequestDeclined.name] = function(p29, p30) -- line: 171
			-- upvalues: llama (copy)
			local ids = p30.ids
			local t11 = {}

			for _, v in pairs(ids) do
				t11[tostring(v)] = Enum.FriendStatus.NotFriend
			end

			return llama.Dictionary.join(p29, t11)
		end
	})
end
