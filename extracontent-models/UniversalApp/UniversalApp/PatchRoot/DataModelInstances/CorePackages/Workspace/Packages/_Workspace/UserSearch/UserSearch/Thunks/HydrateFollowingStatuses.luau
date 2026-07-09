local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local FriendsNetworking = require(UserSearch.Networking.FriendsNetworking)
local RODUX_KEY = require(UserSearch.Common.Constants).RODUX_KEY
local getDeepValue = require(UserSearchParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local hydrateEmptyIdsHelper = require(UserSearchParent.SocialCommon).Utils.hydrateEmptyIdsHelper

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: getDeepValue (copy), RODUX_KEY (copy), hydrateEmptyIdsHelper (copy), FriendsNetworking (copy)
	return function(p1) -- line: 15
		-- upvalues: getDeepValue (copy), RODUX_KEY (copy), hydrateEmptyIdsHelper (copy), t1 (copy), FriendsNetworking (copy)
		local v9 = p1:getState() or {}
		local v10 = getDeepValue(v9, string.format("%s.Friends.followings.followingStatuses", RODUX_KEY)) or {}

		return hydrateEmptyIdsHelper({
			ids = t1,
			selector = function(p2) -- line: 24
				-- upvalues: v10 (copy)
				return v10[p2]
			end,
			hydrate = function(p3) -- line: 27
				-- upvalues: p1 (copy), FriendsNetworking (copy)
				return p1:dispatch(FriendsNetworking.GetFollowingExists.API({
					targetUserIds = p3
				}))
			end
		})
	end
end
