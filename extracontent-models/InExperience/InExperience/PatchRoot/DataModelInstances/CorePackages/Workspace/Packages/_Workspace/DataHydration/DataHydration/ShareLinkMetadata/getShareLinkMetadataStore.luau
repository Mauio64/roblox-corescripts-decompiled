local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createShareLinkMetadataStore = require(script.Parent.createShareLinkMetadataStore)

return Signals.createComputed(function()
	return createShareLinkMetadataStore()
end)
