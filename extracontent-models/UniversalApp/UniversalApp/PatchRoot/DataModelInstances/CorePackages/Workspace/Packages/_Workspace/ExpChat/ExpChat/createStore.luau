local Parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(Parent.Rodux)
local RaiseActionAsEventMiddleware = require(Parent.ExpChatShared).RaiseActionAsEventMiddleware
local installReducer = require(script.Parent.installReducer)

local function createStore(p1) -- line: 8
	-- upvalues: Rodux (copy), installReducer (copy), RaiseActionAsEventMiddleware (copy)
	return Rodux.Store.new(installReducer, p1, {
		Rodux.thunkMiddleware,
		RaiseActionAsEventMiddleware
	})
end

return createStore
