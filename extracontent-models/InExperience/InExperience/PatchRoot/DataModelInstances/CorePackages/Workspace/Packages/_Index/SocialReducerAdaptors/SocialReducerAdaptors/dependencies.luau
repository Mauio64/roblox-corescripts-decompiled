local ParentParent = script.Parent.Parent
local LuaSocialLibrariesDeps = require(ParentParent.LuaSocialLibrariesDeps)

return {
	Players = game:GetService("Players"),
	llama = LuaSocialLibrariesDeps.llama,
	Rodux = require(ParentParent.Rodux)
}
