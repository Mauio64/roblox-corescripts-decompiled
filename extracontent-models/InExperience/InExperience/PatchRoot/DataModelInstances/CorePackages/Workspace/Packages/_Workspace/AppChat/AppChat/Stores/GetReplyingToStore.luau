local parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(parent.Signals)

local createReplyingToStore = require(script.createReplyingToStore)

return Signals.createComputed(createReplyingToStore)
