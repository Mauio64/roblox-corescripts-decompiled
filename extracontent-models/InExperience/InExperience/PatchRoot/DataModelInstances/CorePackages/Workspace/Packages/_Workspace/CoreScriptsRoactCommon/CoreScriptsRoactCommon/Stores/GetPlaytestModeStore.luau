local parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent
local Signals = require(parent.Signals)
local createPlaytestModeStore = require(script.createPlaytestModeStore)

return Signals.createComputed(createPlaytestModeStore)
