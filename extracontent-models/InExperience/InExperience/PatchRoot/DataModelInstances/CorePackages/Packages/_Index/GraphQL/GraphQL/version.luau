local parent = script.Parent
local LuauPolyfill = require(parent.Parent.LuauPolyfill)
return {
	version = "15.5.0",
	versionInfo = LuauPolyfill.Object.freeze({
		major = 15,
		minor = 5,
		patch = 0,
		preReleaseTag = ""
	})
}
