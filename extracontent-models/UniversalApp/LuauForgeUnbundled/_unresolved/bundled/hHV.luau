local module = require("@luauforge/bundled/hHW")
return {
	Hooks = {
		useInitializeCrossPlaySettings = require("@luauforge/bundled/hIB"),
		useCrossPlaySettings = module
	},
	Reducers = { CrossPlaySettings = require("@luauforge/bundled/hIA") }
}
