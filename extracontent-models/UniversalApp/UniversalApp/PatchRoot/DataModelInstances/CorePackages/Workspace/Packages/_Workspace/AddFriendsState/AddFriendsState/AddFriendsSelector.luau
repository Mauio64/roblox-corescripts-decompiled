local AddFriendsState = script:FindFirstAncestor("AddFriendsState")
local AddFriendsStateParent = AddFriendsState.Parent
local getDeepValue = require(AddFriendsStateParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local RODUX_KEY = require(AddFriendsState.RODUX_KEY)

return function(p1, s1: string?, ...) -- line: 11
	-- upvalues: getDeepValue (copy), RODUX_KEY (copy)
	local v7 = not s1 and "%s" or "%s." .. s1

	return getDeepValue(p1, string.format(v7, RODUX_KEY, unpack({ ... })))
end
