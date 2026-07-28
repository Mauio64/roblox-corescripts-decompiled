local Parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent
local Signals = require(Parent.Signals)
local createPlaytestModeStore = require(script.createPlaytestModeStore)

return Signals.createComputed(createPlaytestModeStore)
