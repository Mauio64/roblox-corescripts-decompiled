local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local Constants = require(UserSearch.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY
local RoduxFriends = require(parent.RoduxFriends)

return RoduxFriends.config({
	keyPath = RODUX_KEY .. ".Friends"
})
