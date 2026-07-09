local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local FriendsNetworking = require(SocialTabsPageParent.FriendsNetworking)
local myRoduxNetworking = require(SocialTabsPage.Networking.myRoduxNetworking)

return FriendsNetworking.config({
	roduxNetworking = myRoduxNetworking
})
