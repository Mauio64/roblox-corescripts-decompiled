local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Signals = require(Parent.Signals)
local createPasswordManagerUsageStore = require(script.createPasswordManagerUsageStore)

return Signals.createComputed(createPasswordManagerUsageStore)
