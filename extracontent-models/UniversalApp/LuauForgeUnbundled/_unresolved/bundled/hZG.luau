local CorePackages = game:GetService("CorePackages")
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)

return {
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	ShareLinksRodux = require("@luauforge/bundled/hZH").config({})
}
