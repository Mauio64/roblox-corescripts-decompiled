local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local RODUX_KEY = require(UserSearch.Common.Constants).RODUX_KEY

return require(UserSearchParent.LuaSocialLibrariesDeps).RoduxPresence.config({
	keyPath = RODUX_KEY .. ".Presence"
})
