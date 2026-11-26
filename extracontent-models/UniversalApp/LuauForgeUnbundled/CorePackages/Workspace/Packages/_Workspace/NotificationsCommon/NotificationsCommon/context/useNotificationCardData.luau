local React = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/React")
local NotificationCardContext = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/context/NotificationCardContext")

local function useNotificationCardData()
	return (React.useContext(NotificationCardContext))
end

return useNotificationCardData
