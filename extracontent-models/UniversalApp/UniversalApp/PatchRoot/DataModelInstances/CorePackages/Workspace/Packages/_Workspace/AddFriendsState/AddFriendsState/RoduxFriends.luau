local AddFriendsState = script:FindFirstAncestor("AddFriendsState")
local AddFriendsStateParent = AddFriendsState.Parent
local FriendsRodux = require(AddFriendsStateParent.FriendsRodux)
local RODUX_KEY = require(AddFriendsState.RODUX_KEY)

return FriendsRodux.config({
	keyPath = `{ RODUX_KEY }.Friends`
})
