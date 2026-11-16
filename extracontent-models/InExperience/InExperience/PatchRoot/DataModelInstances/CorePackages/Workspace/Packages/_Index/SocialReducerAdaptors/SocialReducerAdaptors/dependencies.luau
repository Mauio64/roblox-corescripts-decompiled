local parent = script.Parent.Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)

return {
	Players = game:GetService("Players"),
	llama = LuaSocialLibrariesDeps.llama,
	Rodux = require(parent.Rodux)
}
