local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Signals = require(scriptParentParent.Signals)
local createHttpStore = require(scriptParent.createHttpStore)

return Signals.createComputed(createHttpStore)
