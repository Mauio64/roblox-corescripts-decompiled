local AddFriendsState = script:FindFirstAncestor("AddFriendsState")
local AddFriendsStateParent = AddFriendsState.Parent
local SocialLuaAnalytics = require(AddFriendsStateParent.SocialLuaAnalytics)
local RODUX_KEY = require(AddFriendsState.RODUX_KEY)

return SocialLuaAnalytics.Analytics.RoduxAnalytics.config({
	keyPath = `{ RODUX_KEY }.Analytics`
})
