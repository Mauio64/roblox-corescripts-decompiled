local parent = script:FindFirstAncestor("ProgressLoading").Parent

local Signals = require(parent.Signals)

local createLoadingScreenStore = require(script.Parent.createLoadingScreenStore)

return Signals.createComputed(createLoadingScreenStore)
