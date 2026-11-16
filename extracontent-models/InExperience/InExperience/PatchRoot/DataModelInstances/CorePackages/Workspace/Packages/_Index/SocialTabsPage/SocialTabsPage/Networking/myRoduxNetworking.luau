local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local RoduxNetworking = require(parent.RoduxNetworking)
local networkImpl = require(SocialTabsPage.Networking.networkImpl)
local Constants = require(SocialTabsPage.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY

return RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = networkImpl
})
