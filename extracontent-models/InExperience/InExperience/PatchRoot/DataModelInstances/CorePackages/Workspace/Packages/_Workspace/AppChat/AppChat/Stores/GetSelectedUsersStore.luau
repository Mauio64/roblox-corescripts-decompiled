local parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(parent.Signals)

local createSelectedUsersStore = require(script.createSelectedUsersStore)

return Signals.createComputed(createSelectedUsersStore)
