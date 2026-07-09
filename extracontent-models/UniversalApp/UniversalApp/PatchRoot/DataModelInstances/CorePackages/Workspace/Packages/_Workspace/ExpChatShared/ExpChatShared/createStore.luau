local Parent = script:FindFirstAncestor("ExpChatShared").Parent
local Rodux = require(Parent.Rodux)
local RaiseActionAsEventMiddleware = require(script.Parent.RaiseActionAsEventMiddleware)
local Reducers = require(script.Parent.Reducers)

local function createStore(p1) -- line: 7
	-- upvalues: Rodux (copy), Reducers (copy), RaiseActionAsEventMiddleware (copy)
	return Rodux.Store.new(Rodux.combineReducers(Reducers), p1, {
		Rodux.thunkMiddleware,
		RaiseActionAsEventMiddleware
	})
end

return createStore
