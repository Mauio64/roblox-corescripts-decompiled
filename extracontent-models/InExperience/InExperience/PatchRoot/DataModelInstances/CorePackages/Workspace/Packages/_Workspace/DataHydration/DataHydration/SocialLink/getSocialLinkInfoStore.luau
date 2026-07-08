local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createSocialLinkInfoStore = require(script.Parent.createSocialLinkInfoStore)

return Signals.createComputed(createSocialLinkInfoStore)
