local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local LuaSocialLibrariesDeps = require(SocialTabsPageParent.LuaSocialLibrariesDeps)
local RODUX_KEY = require(SocialTabsPage.Common.Constants).RODUX_KEY

return LuaSocialLibrariesDeps.RoduxPresence.config({
	keyPath = RODUX_KEY .. ".Presence"
})
