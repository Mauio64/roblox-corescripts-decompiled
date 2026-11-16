local parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)

return {
	t = require(parent.t),
	tutils = require(parent.tutils),
	RoduxPresence = LuaSocialLibrariesDeps.RoduxPresence.config({
		keyPath = "SocialLuaAnalytics.Presence"
	}),
	llama = LuaSocialLibrariesDeps.llama,
	enumerate = require(parent.enumerate),
	LuauPolyfill = require(parent.LuauPolyfill),
	Rodux = require(parent.Rodux),
	Dash = require(parent.Dash)
}
