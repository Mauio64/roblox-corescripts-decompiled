local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")

return React.createContext({
	state = nil,
	cardSize = nil,
	handleActions = nil,
	cardTransparency = nil,
	notificationReceivedTimestampMs = nil,
	timers = nil,
	displayTimestampMs = nil
})
