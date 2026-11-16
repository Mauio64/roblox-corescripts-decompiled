local NotificationCardContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/context/NotificationCardContext")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/type")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/constants")

local analyticsService = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/analytics/analyticsService")

local toastNotificationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/utils/toastNotificationHelper")

local function NotificationCardProvider(props)
	local eventStream = analyticsService.EventStream
	local v5 = {
		thumbnail = constants.CardSizeDefault.thumbnail,
		cardPadding = constants.Padding.DefaultCardPadding
	}

	if props.isCompact then
		v5.thumbnail = constants.CardSizeCompact.thumbnail
		v5.cardPadding = constants.Padding.CompactCardPadding
	end

	local v6

	if props.isCompact then
		v6 = constants.CardTransparency.Compact
	else
		v6 = constants.CardTransparency.Default
	end

	local function fn(p2)
		toastNotificationHelper.fireEvent(eventStream, p2)
	end
	return React.createElement(NotificationCardContext.Provider, {
		value = {
			state = props.state,
			cardSize = v5,
			handleActions = props.handleActions,
			sendEvent = fn,
			cardTransparency = v6,
			notificationReceivedTimestampMs = props.notificationReceivedTimestampMs,
			timers = props.timers,
			displayTimestampMs = props.displayTimestampMs
		}
	}, props.children)
end

return NotificationCardProvider
