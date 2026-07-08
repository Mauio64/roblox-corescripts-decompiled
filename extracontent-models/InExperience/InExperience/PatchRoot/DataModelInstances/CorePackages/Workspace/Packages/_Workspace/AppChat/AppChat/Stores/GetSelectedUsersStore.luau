local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)
local createSelectedUsersStore = require(script.createSelectedUsersStore)

return Signals.createComputed(createSelectedUsersStore)
