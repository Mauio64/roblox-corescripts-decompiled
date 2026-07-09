local CorePackages = game:GetService("CorePackages")
local v2 = require(CorePackages.Packages.LuaSocialLibrariesDeps).SocialLibraries.config({})
local v3 = require(CorePackages.Workspace.Packages.ShareLinksRodux).config({})

return {
	SocialLibraries = v2,
	ShareLinksRodux = v3
}
