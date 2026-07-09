local Parent = script:FindFirstAncestor("CoreGuiCommon").Parent
local Signals = require(Parent.Signals)
local createLocalHumanoidStore = require(script.createLocalHumanoidStore)

return Signals.createComputed(createLocalHumanoidStore)
