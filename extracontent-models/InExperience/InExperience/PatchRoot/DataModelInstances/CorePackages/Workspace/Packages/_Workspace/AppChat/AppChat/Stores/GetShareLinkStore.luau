local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)
local createShareLinkStore = require(script.createShareLinkStore)

return Signals.createComputed(createShareLinkStore)
