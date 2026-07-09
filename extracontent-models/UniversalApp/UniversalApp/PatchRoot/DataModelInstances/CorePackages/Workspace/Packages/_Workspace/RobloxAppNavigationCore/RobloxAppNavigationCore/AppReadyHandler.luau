local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local useNavigation = require(ParentParent.Navigation).useNavigation
local useRoactService = require(ParentParent.RobloxAppHooks).useRoactService
local AppGuiService = require(ParentParent.RoactServiceTags).AppGuiService
local NotificationType = require(ParentParent.RobloxAppEnums).NotificationType

local function AppReadyHandler(t1: {[any]: any}) -- line: 13
	-- upvalues: React (copy), NotificationType (copy), AppReadyHandler (copy)
	React.useEffect(function() -- line: 16
		-- upvalues: t1 (copy), NotificationType (copy)
		if t1.state.routeName ~= nil then
			t1.guiService:BroadcastNotification(t1.state.routeName, NotificationType.APP_READY)
		end
	end, { t1.state.routeName })

	if t1.state.routes ~= nil then
		return React.createElement(AppReadyHandler, {
			state = t1.state.routes[t1.state.index],
			guiService = t1.guiService
		})
	end

	return nil
end

return function(_: {[any]: any}) -- line: 31
	-- upvalues: useNavigation (copy), useRoactService (copy), AppGuiService (copy), React (copy), AppReadyHandler (copy)
	local v10 = useNavigation()
	local v11 = useRoactService(AppGuiService)

	return React.createElement(AppReadyHandler, {
		state = v10.state,
		guiService = v11
	})
end
