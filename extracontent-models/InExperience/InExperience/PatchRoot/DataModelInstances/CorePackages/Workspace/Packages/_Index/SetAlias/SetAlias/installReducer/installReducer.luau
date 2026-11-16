local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)

local rodux = dependencies.Rodux
local roduxNetworking = dependencies.RoduxNetworking
local roduxAliases = dependencies.RoduxAliases

return function()
	return rodux.combineReducers({
		Aliases = roduxAliases.installReducer(),
		NetworkStatus = roduxNetworking.installReducer()
	})
end
