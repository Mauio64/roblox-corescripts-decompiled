local parent = script:FindFirstAncestor("UserLib").Parent

local Signals = require(parent.Signals)
local createIsLocalUserUnder13Store = require(script.createIsLocalUserUnder13Store)

return Signals.createComputed(createIsLocalUserUnder13Store)
