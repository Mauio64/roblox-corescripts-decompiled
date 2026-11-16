local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local createImmersiveChromeStore = require(script.createImmersiveChromeStore)

return Signals.createComputed(createImmersiveChromeStore)
