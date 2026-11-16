local parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(parent.Signals)
local createLocalHumanoidStore = require(script.createLocalHumanoidStore)

return Signals.createComputed(createLocalHumanoidStore)
