local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local useSelector = require(UserSearchParent.RoactUtils).Hooks.RoactRodux.useSelector
local RODUX_KEY = require(UserSearch.Common.Constants).RODUX_KEY
local getDeepValue = require(UserSearchParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue

return function(s1: string) -- line: 16
	-- upvalues: useSelector (copy), getDeepValue (copy), RODUX_KEY (copy)
	return useSelector(function(p1) -- line: 17
		-- upvalues: getDeepValue (copy), RODUX_KEY (copy), s1 (copy)
		local v8 = getDeepValue(p1, string.format("%s.Friends.friendshipStatus.%s", RODUX_KEY, s1))
		local v9 = getDeepValue(p1, string.format("%s.Friends.followings.followingStatuses.%s", RODUX_KEY, s1)) or {}

		return {
			status = v8,
			following = v9.isFollowing or false,
			isMyself = p1.LocalUserId == s1
		}
	end)
end
