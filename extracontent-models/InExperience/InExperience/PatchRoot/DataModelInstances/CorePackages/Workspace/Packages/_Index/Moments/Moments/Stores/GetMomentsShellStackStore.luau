local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createMomentsShellStackStore = require(script.createMomentsShellStackStore)

return Signals.createComputed(createMomentsShellStackStore)
