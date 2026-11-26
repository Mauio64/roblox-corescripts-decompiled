local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")
local NotificationCardContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/context/NotificationCardContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")

local function useNotificationCardState(p2)
	local v5 = React.useContext(NotificationCardContext)

	if p2 then
		return v5.state and v5.state.visualItems and v5.state.visualItems[p2] or {}
	end

	return v5.state
end

return useNotificationCardState
