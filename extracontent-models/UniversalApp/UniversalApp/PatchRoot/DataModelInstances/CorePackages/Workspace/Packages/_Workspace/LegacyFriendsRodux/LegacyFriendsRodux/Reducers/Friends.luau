local LegacyFriendsRodux = script:FindFirstAncestor("LegacyFriendsRodux")
local LegacyFriendsRoduxParent = LegacyFriendsRodux.Parent
local Immutable = require(LegacyFriendsRoduxParent.AppCommonLib).Immutable
local RetrievalStatus = require(LegacyFriendsRoduxParent.Http).Enum.RetrievalStatus
local FetchUserFriendsStarted = require(LegacyFriendsRodux.Actions).FetchUserFriendsStarted
local FetchUserFriendsFailed = require(LegacyFriendsRodux.Actions).FetchUserFriendsFailed
local FetchUserFriendsCompleted = require(LegacyFriendsRodux.Actions).FetchUserFriendsCompleted

local function setFieldPerUser(p1, p2, p3, p4) -- line: 11
	-- upvalues: Immutable (copy)
	local v15 = p1[p2] or {}

	return Immutable.JoinDictionaries(p1, {
		[p2] = Immutable.JoinDictionaries(v15, {
			[p3] = p4
		})
	})
end
local function setRetrievalStatus(p5, p6, p7) -- line: 20
	-- upvalues: setFieldPerUser (copy)
	return setFieldPerUser(p5, "retrievalStatus", p6, p7)
end
local function setRetrievalFailureResponse(p8, p9, p10) -- line: 24
	-- upvalues: setFieldPerUser (copy)
	return setFieldPerUser(p8, "retrievalFailureResponse", p9, p10)
end

return function(p11, p12) -- line: 28
	-- upvalues: FetchUserFriendsStarted (copy), RetrievalStatus (copy), setFieldPerUser (copy), FetchUserFriendsFailed (copy), FetchUserFriendsCompleted (copy)
	local v24 = p11 or {
		retrievalStatus = {},
		retrievalFailureResponse = {}
	}

	if p12.type == FetchUserFriendsStarted.name then
		local userId = p12.userId
		local Fetching = RetrievalStatus.Fetching

		return (setFieldPerUser(v24, "retrievalStatus", userId, Fetching))
	end

	if p12.type == FetchUserFriendsFailed.name then
		local userId = p12.userId
		local Failed = RetrievalStatus.Failed
		local v29 = setFieldPerUser(v24, "retrievalStatus", userId, Failed)
		local userId2 = p12.userId
		local response = p12.response

		return (setFieldPerUser(v29, "retrievalFailureResponse", userId2, response))
	end

	if p12.type == FetchUserFriendsCompleted.name then
		local userId = p12.userId
		local Done = RetrievalStatus.Done

		v24 = setFieldPerUser(v24, "retrievalStatus", userId, Done)
	end

	return v24
end
