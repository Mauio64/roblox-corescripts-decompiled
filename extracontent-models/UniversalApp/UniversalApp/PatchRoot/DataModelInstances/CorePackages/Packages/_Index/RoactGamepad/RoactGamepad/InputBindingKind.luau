local parent = script.Parent.Parent
local enumerate = require(parent.enumerate)

return enumerate("InputBindingKind", { "Begin", "End", "Step", "MoveStep" })
