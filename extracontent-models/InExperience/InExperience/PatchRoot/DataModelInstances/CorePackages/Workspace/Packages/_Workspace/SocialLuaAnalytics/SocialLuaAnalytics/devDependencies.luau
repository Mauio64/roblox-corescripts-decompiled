local parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent

local FriendsRodux = require(parent.Dev.FriendsRodux)

return {
	RoduxFriends = FriendsRodux.config({ keyPath = "SocialLuaAnalytics.Friends" })
}
