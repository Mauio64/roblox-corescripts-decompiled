local parent = script:FindFirstAncestor("ServerTriggeredModals").Parent

local Signals = require(parent.Signals)

local createModalSignalStore = require(script.Parent.createModalSignalStore)

return Signals.createComputed(createModalSignalStore)
