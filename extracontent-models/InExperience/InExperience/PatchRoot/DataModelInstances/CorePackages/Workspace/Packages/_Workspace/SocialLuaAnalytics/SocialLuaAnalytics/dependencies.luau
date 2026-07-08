local Parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent
local LuaSocialLibrariesDeps = require(Parent.LuaSocialLibrariesDeps)

return {
	t = require(Parent.t),
	tutils = require(Parent.tutils),
	RoduxPresence = LuaSocialLibrariesDeps.RoduxPresence.config({
		keyPath = "SocialLuaAnalytics.Presence"
	}),
	llama = LuaSocialLibrariesDeps.llama,
	enumerate = require(Parent.enumerate),
	LuauPolyfill = require(Parent.LuauPolyfill),
	Rodux = require(Parent.Rodux),
	Dash = require(Parent.Dash)
}
