local module = require("@luauforge/bundled/hRE")

return {
	Components = { SupportRegionAvatarOverlayContainer = require("@luauforge/bundled/hRH") },
	Hooks = { useOverlayFocusNavigationBindings = require("@luauforge/bundled/hSs") },
	Providers = { SupportOverlayMonolithDependenciesContext = module }
}
