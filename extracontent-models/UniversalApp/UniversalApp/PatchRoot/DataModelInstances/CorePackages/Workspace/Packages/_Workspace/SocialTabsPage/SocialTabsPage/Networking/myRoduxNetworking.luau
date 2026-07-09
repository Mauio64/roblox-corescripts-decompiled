local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local RoduxNetworking = require(SocialTabsPageParent.RoduxNetworking)
local networkImpl = require(SocialTabsPage.Networking.networkImpl)
local RODUX_KEY = require(SocialTabsPage.Common.Constants).RODUX_KEY

return RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = networkImpl
})
