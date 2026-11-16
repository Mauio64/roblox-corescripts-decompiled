local parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(parent.Signals)

local createUnreadMessageCountStore = require(script.createUnreadMessageCountStore)

return Signals.createComputed(createUnreadMessageCountStore)
