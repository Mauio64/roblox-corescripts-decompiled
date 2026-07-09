local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local Rodux = dependencies.Rodux
local RoduxNetworking = dependencies.RoduxNetworking
local RoduxAliases = dependencies.RoduxAliases

return function() -- line: 8
	-- upvalues: Rodux (copy), RoduxAliases (copy), RoduxNetworking (copy)
	return Rodux.combineReducers({
		Aliases = RoduxAliases.installReducer(),
		NetworkStatus = RoduxNetworking.installReducer()
	})
end
