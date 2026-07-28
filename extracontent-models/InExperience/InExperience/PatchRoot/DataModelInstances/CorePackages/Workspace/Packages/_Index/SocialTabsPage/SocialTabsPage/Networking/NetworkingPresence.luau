local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent

if require(SocialTabsPage.Flags.FFlagSocialTabsPagePresenceSignalsMigration) then
	return nil
end

local LuaSocialLibrariesDeps = require(SocialTabsPageParent.LuaSocialLibrariesDeps)
local myRoduxNetworking = require(SocialTabsPage.Networking.myRoduxNetworking)

return LuaSocialLibrariesDeps.NetworkingPresence.config({
	roduxNetworking = myRoduxNetworking
})
