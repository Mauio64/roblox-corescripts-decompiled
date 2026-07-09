local TextSize = script:FindFirstAncestor("TextSize")
local TextSizeParent = TextSize.Parent
local Signals = require(TextSizeParent.Signals)
local createTextSizeStore = require(TextSize.createTextSizeStore)

return Signals.createComputed(createTextSizeStore)
