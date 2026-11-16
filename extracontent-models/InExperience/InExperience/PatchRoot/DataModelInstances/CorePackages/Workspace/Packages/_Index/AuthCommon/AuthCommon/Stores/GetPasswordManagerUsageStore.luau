local parent = script:FindFirstAncestor("AuthCommon").Parent

local Signals = require(parent.Signals)
local createPasswordManagerUsageStore = require(script.createPasswordManagerUsageStore)

return Signals.createComputed(createPasswordManagerUsageStore)
