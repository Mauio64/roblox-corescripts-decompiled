local Parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(Parent.Signals)
local createInspectAndBuyStore = require(script.createInspectAndBuyStore)

return Signals.createComputed(createInspectAndBuyStore)
