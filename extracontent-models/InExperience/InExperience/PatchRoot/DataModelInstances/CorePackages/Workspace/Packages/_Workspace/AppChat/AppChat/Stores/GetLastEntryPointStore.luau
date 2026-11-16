local parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(parent.Signals)

local createLastEntryPointStore = require(script.createLastEntryPointStore)

return Signals.createComputed(createLastEntryPointStore)
