local parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(parent.Signals)
local createInspectAndBuyStore = require(script.createInspectAndBuyStore)

return Signals.createComputed(createInspectAndBuyStore)
