local parent = script:FindFirstAncestor("ExpChatServer").Parent
local Rodux = require(parent.Rodux)

local installReducer = require(script.Parent.installReducer)

local function createStore()
	return Rodux.Store.new(installReducer, nil, { Rodux.thunkMiddleware })
end

return createStore
