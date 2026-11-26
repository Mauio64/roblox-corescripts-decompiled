local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialReducerAdaptors/LuaSocialLibrariesDeps")

return {
	Players = game:GetService("Players"),
	llama = LuaSocialLibrariesDeps.llama,
	Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialReducerAdaptors/Rodux")
}
