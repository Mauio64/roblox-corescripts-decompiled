local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/dependencies")

local rodux = dependencies.Rodux
local roduxNetworking = dependencies.RoduxNetworking
local roduxAliases = dependencies.RoduxAliases

return function()
	return rodux.combineReducers({
		Aliases = roduxAliases.installReducer(),
		NetworkStatus = roduxNetworking.installReducer()
	})
end
