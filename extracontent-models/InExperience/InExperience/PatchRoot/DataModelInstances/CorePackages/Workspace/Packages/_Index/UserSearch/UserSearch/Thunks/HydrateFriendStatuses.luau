local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local FriendsNetworking = require(UserSearch.Networking.FriendsNetworking)
local Constants = require(UserSearch.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue

local SocialCommon = require(parent.SocialCommon)
local hydrateEmptyIdsHelper = SocialCommon.Utils.hydrateEmptyIdsHelper

return function(ids)
	return function(object)
		local v = object:getState() or {}
		local v2 = getDeepValue(v, string.format("%s.Friends.friendshipStatus", RODUX_KEY)) or {}

		return hydrateEmptyIdsHelper({
			ids = ids,
			selector = function(p)
				return v2[p]
			end,
			hydrate = function(targetUserIds)
				return object:dispatch(FriendsNetworking.GetFriendshipStatuses.API({
					currentUserId = v.LocalUserId,
					targetUserIds = targetUserIds
				}))
			end
		})
	end
end
