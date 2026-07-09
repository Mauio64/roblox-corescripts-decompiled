local Parent = script:FindFirstAncestor("ExpChatServer").Parent
local Rodux = require(Parent.Rodux)
local installReducer = require(script.Parent.installReducer)

local function createStore() -- line: 6
	-- upvalues: Rodux (copy), installReducer (copy)
	return Rodux.Store.new(installReducer, nil, { Rodux.thunkMiddleware })
end

return createStore
