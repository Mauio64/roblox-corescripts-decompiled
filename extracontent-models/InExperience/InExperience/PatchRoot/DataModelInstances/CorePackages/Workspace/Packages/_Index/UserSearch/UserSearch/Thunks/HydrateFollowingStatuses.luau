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
		local v = getDeepValue(
				object:getState() or {},
				string.format("%s.Friends.followings.followingStatuses", RODUX_KEY)
			)
			or {}

		return hydrateEmptyIdsHelper({
			ids = ids,
			selector = function(p)
				return v[p]
			end,
			hydrate = function(targetUserIds)
				return object:dispatch(FriendsNetworking.GetFollowingExists.API({
					targetUserIds = targetUserIds
				}))
			end
		})
	end
end
