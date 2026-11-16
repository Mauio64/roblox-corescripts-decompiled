local immutable = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/AppCommonLib").Immutable
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/Http").Enum.RetrievalStatus

local fetchUserFriendsStarted = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/LegacyFriendsRodux/Actions").FetchUserFriendsStarted
local fetchUserFriendsFailed = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/LegacyFriendsRodux/Actions").FetchUserFriendsFailed
local fetchUserFriendsCompleted = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/LegacyFriendsRodux/Actions").FetchUserFriendsCompleted

local function setFieldPerUser(p2, p3, p4, p5)
	local v5 = p2[p3] or {}
	return immutable.JoinDictionaries(p2, {
		[p3] = immutable.JoinDictionaries(v5, { [p4] = p5 })
	})
end

local function setRetrievalStatus(p2, p3, p4)
	return setFieldPerUser(p2, "retrievalStatus", p3, p4)
end

local function setRetrievalFailureResponse(p2, p3, p4)
	return setFieldPerUser(p2, "retrievalFailureResponse", p3, p4)
end

return function(p2, data)
	local v5 = p2 or { retrievalStatus = {}, retrievalFailureResponse = {} }

	if data.type == fetchUserFriendsStarted.name then
		return (setFieldPerUser(v5, "retrievalStatus", data.userId, retrievalStatus.Fetching))
	elseif data.type == fetchUserFriendsFailed.name then
		return (setFieldPerUser(
			setFieldPerUser(v5, "retrievalStatus", data.userId, retrievalStatus.Failed),
			"retrievalFailureResponse",
			data.userId,
			data.response
		))
	else
		if data.type == fetchUserFriendsCompleted.name then
			v5 = setFieldPerUser(v5, "retrievalStatus", data.userId, retrievalStatus.Done)
		end

		return v5
	end
end
