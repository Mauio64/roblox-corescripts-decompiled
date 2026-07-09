local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local LuaSocialLibrariesDeps = require(SocialTabsPageParent.LuaSocialLibrariesDeps)
local myRoduxNetworking = require(SocialTabsPage.Networking.myRoduxNetworking)

return LuaSocialLibrariesDeps.NetworkingPresence.config({
	roduxNetworking = myRoduxNetworking
})
