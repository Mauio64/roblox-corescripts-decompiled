local Parent = script:FindFirstAncestor("ServerTriggeredModals").Parent
local Signals = require(Parent.Signals)
local createModalSignalStore = require(script.Parent.createModalSignalStore)

return Signals.createComputed(createModalSignalStore)
