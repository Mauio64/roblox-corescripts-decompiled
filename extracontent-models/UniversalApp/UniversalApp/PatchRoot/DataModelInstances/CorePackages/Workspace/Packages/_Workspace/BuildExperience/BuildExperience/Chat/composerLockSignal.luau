local Parent = script:FindFirstAncestor("BuildExperience").Parent
local v2, v3 = require(Parent.Signals).createSignal("normal")

return {
	getComposerMode = v2,
	setComposerMode = v3
}
