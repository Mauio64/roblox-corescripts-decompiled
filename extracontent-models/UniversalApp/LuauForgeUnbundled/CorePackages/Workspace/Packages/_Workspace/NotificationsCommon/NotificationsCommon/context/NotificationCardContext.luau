local React = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/type")

return React.createContext({
	notificationPayload = nil,
	state = nil,
	cardSize = nil,
	handleActions = nil,
	openMetaActions = nil,
	readOnly = nil,
	cardTransparency = nil
})
