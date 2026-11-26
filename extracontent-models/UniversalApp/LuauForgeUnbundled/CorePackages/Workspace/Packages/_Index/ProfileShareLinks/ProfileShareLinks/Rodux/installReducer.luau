local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/Rodux")

local configuredRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Networking/configuredRoduxNetworking")
local ProfileShareLinksReducer = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Rodux/ProfileShareLinksReducer")

return function()
	return Rodux.combineReducers({
		ProfileShareLinks = ProfileShareLinksReducer,
		NetworkingStatus = configuredRoduxNetworking.installReducer()
	})
end
