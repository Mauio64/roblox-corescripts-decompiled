local parent = script:FindFirstAncestor("UserAccessStore").Parent

local Signals = require(parent.Signals)
local createUserAccessStore = require(script.createUserAccessStore)

return Signals.createComputed(createUserAccessStore)
