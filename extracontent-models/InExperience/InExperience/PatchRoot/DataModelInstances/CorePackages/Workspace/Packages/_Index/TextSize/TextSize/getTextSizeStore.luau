local TextSize = script:FindFirstAncestor("TextSize")
local parent = TextSize.Parent
local Signals = require(parent.Signals)
local createTextSizeStore = require(TextSize.createTextSizeStore)

return Signals.createComputed(createTextSizeStore)
