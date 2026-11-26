local FriendsNetworking = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Networking/FriendsNetworking")
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Common/Constants").RODUX_KEY
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/LuaSocialLibrariesDeps").SocialLibraries.config({}).Dictionary.getDeepValue

local hydrateEmptyIdsHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/SocialCommon").Utils.hydrateEmptyIdsHelper

return function(p2)
	return function(object)
		local v6 = getDeepValue(
				object:getState() or {},
				string.format("%s.Friends.followings.followingStatuses", RODUX_KEY)
			)
			or {}

		return hydrateEmptyIdsHelper({
			ids = p2,
			selector = function(p3)
				return v6[p3]
			end,
			hydrate = function(p3)
				return object:dispatch(FriendsNetworking.GetFollowingExists.API({
					targetUserIds = p3
				}))
			end
		})
	end
end
