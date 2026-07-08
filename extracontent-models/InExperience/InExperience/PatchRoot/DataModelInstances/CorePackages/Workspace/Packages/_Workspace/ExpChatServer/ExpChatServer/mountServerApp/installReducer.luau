local Parent = script:FindFirstAncestor("ExpChatServer").Parent
local Rodux = require(Parent.Rodux)
local ExpChatShared = require(Parent.ExpChatShared)

return Rodux.combineReducers({
	Players = ExpChatShared.Reducers.Players
})
