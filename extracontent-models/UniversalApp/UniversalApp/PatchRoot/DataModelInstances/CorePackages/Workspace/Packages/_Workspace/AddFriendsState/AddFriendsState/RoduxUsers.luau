local AddFriendsState = script:FindFirstAncestor("AddFriendsState")
local AddFriendsStateParent = AddFriendsState.Parent
local RoduxUsers = require(AddFriendsStateParent.RoduxUsers)
local RODUX_KEY = require(AddFriendsState.RODUX_KEY)

return RoduxUsers.config({
	keyPath = `{ RODUX_KEY }.Users`
})
