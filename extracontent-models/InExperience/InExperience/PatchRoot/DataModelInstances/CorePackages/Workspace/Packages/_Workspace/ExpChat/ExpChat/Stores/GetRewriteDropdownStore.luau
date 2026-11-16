local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createRewriteDropdownStore = require(script.createRewriteDropdownStore)

return Signals.createComputed(createRewriteDropdownStore)
