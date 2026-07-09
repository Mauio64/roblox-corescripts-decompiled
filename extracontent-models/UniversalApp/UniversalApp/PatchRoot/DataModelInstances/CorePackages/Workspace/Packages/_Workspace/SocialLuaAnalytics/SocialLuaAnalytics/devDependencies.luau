local Parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent

return {
	RoduxFriends = require(Parent.Dev.FriendsRodux).config({
		keyPath = "SocialLuaAnalytics.Friends"
	})
}
