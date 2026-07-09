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

local function mapFriendshipStatusToEnum(s1: string) -- line: 16
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
local function difference(t2: {[any]: any}, t3: {[any]: any}) -- line: 30
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

return function(p1) -- line: 52
	-- upvalues: Rodux (copy), t1 (copy), llama (copy), difference (copy), FriendshipDestroyed (copy), FriendshipCreated (copy), FriendRequestCreated (copy), FriendRequestDeclined (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(t1, {
		[friendsNetworking.GetFriendshipStatus.Succeeded.name] = function(p2, p3) -- line: 55
			-- upvalues: llama (copy)
			local t6 = {}

			for _, v in pairs(p3.responseBody.data) do
				local str = tostring(v.id)
				local status = v.status

				t6[str] = if status ~= "NotFriends" then if status ~= "Friends" then if status ~= "RequestSent" then if status ~= "RequestReceived" then Enum.FriendStatus.Unknown else Enum.FriendStatus.FriendRequestReceived else Enum.FriendStatus.FriendRequestSent else Enum.FriendStatus.Friend else Enum.FriendStatus.NotFriend
			end

			return llama.Dictionary.join(p2, t6)
		end,
		[friendsNetworking.GetFriendshipStatuses.Succeeded.name] = function(p4, p5) -- line: 66
			-- upvalues: llama (copy)
			local t7 = {}

			for _, v in pairs(p5.responseBody.data) do
				local str = tostring(v.id)
				local status = v.status

				t7[str] = if status ~= "NotFriends" then if status ~= "Friends" then if status ~= "RequestSent" then if status ~= "RequestReceived" then Enum.FriendStatus.Unknown else Enum.FriendStatus.FriendRequestReceived else Enum.FriendStatus.FriendRequestSent else Enum.FriendStatus.Friend else Enum.FriendStatus.NotFriend
			end

			return llama.Dictionary.join(p4, t7)
		end,
		[friendsNetworking.GetExtendedFriendshipStatus.Succeeded.name] = function(p6, p7) -- line: 77
			-- upvalues: llama (copy)
			local str = tostring(p7.ids[1])
			local join = llama.Dictionary.join
			local t8 = {}
			local status = p7.responseBody.status

			t8[str] = if status ~= "NotFriends" then if status ~= "Friends" then if status ~= "RequestSent" then if status ~= "RequestReceived" then Enum.FriendStatus.Unknown else Enum.FriendStatus.FriendRequestReceived else Enum.FriendStatus.FriendRequestSent else Enum.FriendStatus.Friend else Enum.FriendStatus.NotFriend

			return join(p6, t8)
		end,
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p8, p9) -- line: 82
			-- upvalues: llama (copy), difference (copy)
			local v49 = llama.Dictionary.keys(llama.Dictionary.filter(p8, function(p10) -- line: 86
				return p10 == Enum.FriendStatus.Friend
			end))
			local v50 = llama.List.map(llama.Dictionary.values(p9.responseBody.data), function(p11) -- line: 89
				return (tostring(p11.id))
			end)
			local v51 = difference(v50, v49)
			local v52 = difference(v49, v50)

			for _, v in pairs(v51) do
				p8 = llama.Dictionary.join(p8, {
					[v] = Enum.FriendStatus.Friend
				})
			end

			for _, v in pairs(v52) do
				p8 = llama.Dictionary.join(p8, {
					[v] = Enum.FriendStatus.Unknown
				})
			end

			return p8
		end,
		[friendsNetworking.UnfriendTargetUserId.Succeeded.name] = function(p12, p13) -- line: 108
			-- upvalues: llama (copy)
			local str = tostring(p13.namedIds.users)

			return llama.Dictionary.join(p12, {
				[str] = Enum.FriendStatus.NotFriend
			})
		end,
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p14, p15) -- line: 118
			-- upvalues: llama (copy)
			local str = tostring(p15.ids[1])

			return llama.Dictionary.join(p14, {
				[str] = Enum.FriendStatus.Friend
			})
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(p16, p17) -- line: 128
			-- upvalues: llama (copy)
			local ids = p17.ids
			local t9 = {}

			for _, v in pairs(ids) do
				t9[tostring(v)] = Enum.FriendStatus.NotFriend
			end

			return llama.Dictionary.join(p16, t9)
		end,
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p18, p19) -- line: 140
			-- upvalues: llama (copy)
			local data = p19.responseBody.data
			local t10 = {}

			for _, v in pairs(data) do
				t10[tostring(v.id)] = Enum.FriendStatus.FriendRequestReceived
			end

			return llama.Dictionary.join(p18, t10)
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function(p20) -- line: 152
			-- upvalues: llama (copy)
			local t11 = {}

			for k, v in pairs(p20) do
				if v == Enum.FriendStatus.FriendRequestReceived then
					t11[tostring(k)] = Enum.FriendStatus.NotFriend
				end
			end

			return llama.Dictionary.join(p20, t11)
		end,
		[friendsNetworking.RequestFriendshipFromUserId.Succeeded.name] = function(p21, p22) -- line: 164
			-- upvalues: llama (copy)
			local str = tostring(p22.namedIds.users)

			return llama.Dictionary.join(p21, {
				[str] = Enum.FriendStatus.FriendRequestSent
			})
		end,
		[friendsNetworking.RequestFriendshipFromContactId.Succeeded.name] = function(p23, p24) -- line: 174
			-- upvalues: llama (copy)
			local str = tostring(p24.namedIds.contacts)

			return llama.Dictionary.join(p23, {
				[str] = Enum.FriendStatus.FriendRequestSent
			})
		end,
		[FriendshipDestroyed.name] = function(p25, p26) -- line: 184
			-- upvalues: llama (copy)
			local str = tostring(p26.payload.userId1)

			return llama.Dictionary.join(p25, {
				[str] = Enum.FriendStatus.NotFriend
			})
		end,
		[FriendshipCreated.name] = function(p27, p28) -- line: 194
			-- upvalues: llama (copy)
			local str = tostring(p28.payload.userId1)

			return llama.Dictionary.join(p27, {
				[str] = Enum.FriendStatus.Friend
			})
		end,
		[FriendRequestCreated.name] = function(p29, p30) -- line: 204
			-- upvalues: llama (copy)
			local str = tostring(p30.requesteeId)

			return llama.Dictionary.join(p29, {
				[str] = Enum.FriendStatus.FriendRequestReceived
			})
		end,
		[FriendRequestDeclined.name] = function(p31, p32) -- line: 214
			-- upvalues: llama (copy)
			local ids = p32.ids
			local t12 = {}

			for _, v in pairs(ids) do
				t12[tostring(v)] = Enum.FriendStatus.NotFriend
			end

			return llama.Dictionary.join(p31, t12)
		end
	})
end
