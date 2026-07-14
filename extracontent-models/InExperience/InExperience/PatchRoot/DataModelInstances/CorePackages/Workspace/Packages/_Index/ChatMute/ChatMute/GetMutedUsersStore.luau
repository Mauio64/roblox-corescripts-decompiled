local Parent = script:FindFirstAncestor("ChatMute").Parent
local Signals = require(Parent.Signals)
local createMutedUsersStore = require(script.Parent.createMutedUsersStore)

return Signals.createComputed(createMutedUsersStore)
