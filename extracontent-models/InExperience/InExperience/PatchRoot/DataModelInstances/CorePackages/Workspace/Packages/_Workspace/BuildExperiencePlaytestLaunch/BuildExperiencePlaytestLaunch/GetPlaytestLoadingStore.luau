local parent = script:FindFirstAncestor("BuildExperiencePlaytestLaunch").Parent

local Signals = require(parent.Signals)
local createPlaytestLoadingStore = require(script.createPlaytestLoadingStore)

return Signals.createComputed(createPlaytestLoadingStore)
