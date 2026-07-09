local AddFriendsState = script:FindFirstAncestor("AddFriendsState")
local AddFriendsStateParent = AddFriendsState.Parent
local RoduxGames = require(AddFriendsStateParent.RoduxGames)
local RODUX_KEY = require(AddFriendsState.RODUX_KEY)

return RoduxGames.config({
	keyPath = `{ RODUX_KEY }.Games`
})
