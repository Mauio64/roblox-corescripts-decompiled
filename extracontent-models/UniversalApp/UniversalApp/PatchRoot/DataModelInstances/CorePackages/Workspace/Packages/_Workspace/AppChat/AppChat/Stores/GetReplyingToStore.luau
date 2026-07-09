local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)
local createReplyingToStore = require(script.createReplyingToStore)

return Signals.createComputed(createReplyingToStore)
