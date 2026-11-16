local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local FriendsNetworking = require(parent.FriendsNetworking)
local myRoduxNetworking = require(SocialTabsPage.Networking.myRoduxNetworking)

return FriendsNetworking.config({ roduxNetworking = myRoduxNetworking })
