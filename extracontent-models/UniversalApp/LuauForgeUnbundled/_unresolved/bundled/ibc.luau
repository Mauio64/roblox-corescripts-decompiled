local module = require("@luauforge/bundled/ibd")

return {
	Components = { SupportRegionAvatarOverlayContainer = require("@luauforge/bundled/ibg") },
	Hooks = { useOverlayFocusNavigationBindings = require("@luauforge/bundled/ibR") },
	Providers = { SupportOverlayMonolithDependenciesContext = module }
}
