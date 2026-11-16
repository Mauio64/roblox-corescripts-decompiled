local parent = script:FindFirstAncestor("ExpChatShared").Parent
local Rodux = require(parent.Rodux)

local RaiseActionAsEventMiddleware = require(script.Parent.RaiseActionAsEventMiddleware)
local Reducers = require(script.Parent.Reducers)

local function createStore(p)
	return Rodux.Store.new(Rodux.combineReducers(Reducers), p, { Rodux.thunkMiddleware, RaiseActionAsEventMiddleware })
end

return createStore
