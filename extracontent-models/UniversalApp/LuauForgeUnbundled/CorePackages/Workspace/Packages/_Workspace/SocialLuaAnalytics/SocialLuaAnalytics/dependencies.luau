local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/LuaSocialLibrariesDeps")

return {
	t = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/t"),
	tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/tutils"),
	RoduxPresence = LuaSocialLibrariesDeps.RoduxPresence.config({
		keyPath = "SocialLuaAnalytics.Presence"
	}),
	llama = LuaSocialLibrariesDeps.llama,
	enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/enumerate"),
	LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/LuauPolyfill"),
	Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Rodux"),
	Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Dash")
}
