local scriptParent = script.Parent
local v2 = require(scriptParent.Parent.LuauPolyfill).Object.freeze({
	major = 15,
	minor = 5,
	patch = 0,
	preReleaseTag = ""
})

return {
	version = "15.5.0",
	versionInfo = v2
}
