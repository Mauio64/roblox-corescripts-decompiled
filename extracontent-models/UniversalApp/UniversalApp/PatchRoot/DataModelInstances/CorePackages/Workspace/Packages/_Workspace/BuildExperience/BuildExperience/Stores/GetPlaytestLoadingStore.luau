local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)
local createPlaytestLoadingStore = require(script.createPlaytestLoadingStore)

return Signals.createComputed(createPlaytestLoadingStore)
