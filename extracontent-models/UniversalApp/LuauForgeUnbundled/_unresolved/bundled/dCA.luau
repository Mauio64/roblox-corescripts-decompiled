local React = require("@game/CorePackages/Workspace/Packages/React")
local useNavigation = require("@luauforge/bundled/dCC").useNavigation
local useRoactService = require("@luauforge/bundled/dCD").useRoactService
local appGuiService = require("@luauforge/bundled/dCE").AppGuiService
local notificationType = require("@luauforge/bundled/dCF").NotificationType
local function AppReadyHandler(p2)
	React.useEffect(function()
		if p2.state.routeName ~= nil then
			p2.guiService:BroadcastNotification(p2.state.routeName, notificationType.APP_READY)
		end
	end, { p2.state.routeName })

	if p2.state.routes == nil then
		return nil
	end

	return React.createElement(AppReadyHandler, {
		state = p2.state.routes[p2.state.index],
		guiService = p2.guiService
	})
end

return function(p2)
	local v5 = useNavigation()
	local v6 = useRoactService(appGuiService)
	return React.createElement(AppReadyHandler, { state = v5.state, guiService = v6 })
end
