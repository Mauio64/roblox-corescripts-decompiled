local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createRewriteDropdownStore = require(script.createRewriteDropdownStore)

return Signals.createComputed(createRewriteDropdownStore)
