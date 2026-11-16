local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local GetCommentSessionFiltersStore = require(script.Parent.GetCommentSessionFiltersStore)
local createCommentCollectionStore = require(script.createCommentCollectionStore)

return Signals.createComputed(function(_)
	return createCommentCollectionStore({
		sessionFilters = GetCommentSessionFiltersStore(false)
	})
end)
