local parent = script:FindFirstAncestor("ExpChatServer").Parent
local Rodux = require(parent.Rodux)
local ExpChatShared = require(parent.ExpChatShared)

return Rodux.combineReducers({ Players = ExpChatShared.Reducers.Players })
