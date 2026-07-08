local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local RODUX_KEY = require(UserList.Common.Constants).RODUX_KEY

return require(UserListParent.LuaSocialLibrariesDeps).RoduxPresence.config({
	keyPath = RODUX_KEY .. ".Presence"
})
