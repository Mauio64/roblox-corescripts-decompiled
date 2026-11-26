local module = require("@luauforge/bundled/hSD")
return {
	Hooks = {
		useInitializeCrossPlaySettings = require("@luauforge/bundled/hTi"),
		useCrossPlaySettings = module
	},
	Reducers = { CrossPlaySettings = require("@luauforge/bundled/hTh") }
}
