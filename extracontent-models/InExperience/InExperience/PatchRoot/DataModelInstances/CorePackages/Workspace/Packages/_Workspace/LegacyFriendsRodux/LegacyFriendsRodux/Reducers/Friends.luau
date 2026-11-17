local LegacyFriendsRodux = script:FindFirstAncestor("LegacyFriendsRodux")
local parent = LegacyFriendsRodux.Parent

local AppCommonLib = require(parent.AppCommonLib)
local Immutable = AppCommonLib.Immutable
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus

local Actions = require(LegacyFriendsRodux.Actions)
local FetchUserFriendsStarted = Actions.FetchUserFriendsStarted
local Actions2 = require(LegacyFriendsRodux.Actions)
local FetchUserFriendsFailed = Actions2.FetchUserFriendsFailed
local Actions3 = require(LegacyFriendsRodux.Actions)
local FetchUserFriendsCompleted = Actions3.FetchUserFriendsCompleted

local function setFieldPerUser(p, p2, p3, p4)
	local v = p[p2] or {}
	return Immutable.JoinDictionaries(p, {
		[p2] = Immutable.JoinDictionaries(v, { [p3] = p4 })
	})
end

local function setRetrievalStatus(p, userId, p2) -- 3 equivalent calls inferred from this helper
	return setFieldPerUser(p, "retrievalStatus", userId, p2)
end

local function setRetrievalFailureResponse(p, userId, response) -- 1 equivalent call inferred from this helper
	return setFieldPerUser(p, "retrievalFailureResponse", userId, response)
end

return function(p, data)
	local v = p or { retrievalStatus = {}, retrievalFailureResponse = {} }

	if data.type == FetchUserFriendsStarted.name then
		return (setRetrievalStatus(v, data.userId, RetrievalStatus.Fetching)) -- inferred equivalent call
	elseif data.type == FetchUserFriendsFailed.name then
		return (setRetrievalFailureResponse( -- inferred equivalent call
			setRetrievalStatus(v, data.userId, RetrievalStatus.Failed), -- inferred equivalent call
			data.userId,
			data.response
		))
	else
		if data.type == FetchUserFriendsCompleted.name then
			return (setRetrievalStatus(v, data.userId, RetrievalStatus.Done)) -- inferred equivalent call
		end

		return v
	end
end
