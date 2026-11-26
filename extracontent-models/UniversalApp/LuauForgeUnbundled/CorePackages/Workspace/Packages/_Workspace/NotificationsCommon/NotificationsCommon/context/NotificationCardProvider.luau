local NotificationCardContext = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/context/NotificationCardContext")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/type")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/constants")

local function NotificationCardProvider(props)
	local v5 = {
		thumbnail = constants.CardSizeDefault.thumbnail,
		cardPadding = constants.Padding.DefaultCardPadding
	}

	if props.isCompact then
		v5.thumbnail = constants.CardSizeCompact.thumbnail
		v5.cardPadding = constants.Padding.CompactCardPadding
	end

	local v6 = if props.isCompact then constants.CardTransparency.Compact else constants.CardTransparency.Default

	return React.createElement(NotificationCardContext.Provider, {
		value = {
			notificationPayload = props.notificationPayload,
			state = props.state,
			cardSize = v5,
			handleActions = props.handleActions,
			openMetaActions = props.openMetaActions,
			readOnly = props.readOnly,
			cardTransparency = v6
		}
	}, props.children)
end

return NotificationCardProvider
