local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createCommentSessionFiltersStore = require(script.createCommentSessionFiltersStore)

return Signals.createComputed(function(_)
	return createCommentSessionFiltersStore()
end)
