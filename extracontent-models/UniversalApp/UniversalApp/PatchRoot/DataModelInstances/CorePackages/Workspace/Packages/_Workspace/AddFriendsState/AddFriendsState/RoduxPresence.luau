local AddFriendsState = script:FindFirstAncestor("AddFriendsState")
local AddFriendsStateParent = AddFriendsState.Parent
local LuaSocialLibrariesDeps = require(AddFriendsStateParent.LuaSocialLibrariesDeps)
local RODUX_KEY = require(AddFriendsState.RODUX_KEY)

return LuaSocialLibrariesDeps.RoduxPresence.config({
	keyPath = `{ RODUX_KEY }.Presence`
})
