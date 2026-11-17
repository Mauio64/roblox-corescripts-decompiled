local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createPostStatusCardStore = require(script.createPostStatusCardStore)

return Signals.createComputed(createPostStatusCardStore)
