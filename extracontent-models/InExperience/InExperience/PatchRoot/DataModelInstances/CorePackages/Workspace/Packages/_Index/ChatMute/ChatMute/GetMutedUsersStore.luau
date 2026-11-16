local parent = script:FindFirstAncestor("ChatMute").Parent
local Signals = require(parent.Signals)
local createMutedUsersStore = require(script.Parent.createMutedUsersStore)

return Signals.createComputed(createMutedUsersStore)
