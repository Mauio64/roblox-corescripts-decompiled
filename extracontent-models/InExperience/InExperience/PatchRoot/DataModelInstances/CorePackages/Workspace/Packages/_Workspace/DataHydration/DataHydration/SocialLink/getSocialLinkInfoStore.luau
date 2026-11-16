local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createSocialLinkInfoStore = require(script.Parent.createSocialLinkInfoStore)

return Signals.createComputed(createSocialLinkInfoStore)
