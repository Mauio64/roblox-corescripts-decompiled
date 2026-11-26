local module = require("@luauforge/bundled/gFI")

local rodux = module.Rodux
local roduxGames = module.RoduxGames
local roduxNetworking = module.RoduxNetworking

return function()
	return rodux.combineReducers({
		Games = roduxGames.installReducer(),
		NetworkStatus = roduxNetworking.installReducer()
	})
end
