local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")
local NotificationCardContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/context/NotificationCardContext")

local function useNotificationCardData()
	return (React.useContext(NotificationCardContext))
end

return useNotificationCardData
