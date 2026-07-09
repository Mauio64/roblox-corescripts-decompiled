local ParentParent = script.Parent.Parent.Parent
local Signals = require(ParentParent.Signals)
local createDisplayStore = require(script.createDisplayStore)

return Signals.createComputed(createDisplayStore)
