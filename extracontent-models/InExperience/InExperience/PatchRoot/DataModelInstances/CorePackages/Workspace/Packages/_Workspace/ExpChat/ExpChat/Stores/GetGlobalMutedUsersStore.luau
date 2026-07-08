local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createGlobalMutedUsersStore = require(script.createGlobalMutedUsersStore)

return Signals.createComputed(createGlobalMutedUsersStore)
