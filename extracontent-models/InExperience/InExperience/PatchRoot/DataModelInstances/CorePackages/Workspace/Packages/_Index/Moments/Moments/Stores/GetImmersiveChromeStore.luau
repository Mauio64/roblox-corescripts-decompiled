local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local createImmersiveChromeStore = require(script.createImmersiveChromeStore)

return Signals.createComputed(createImmersiveChromeStore)
