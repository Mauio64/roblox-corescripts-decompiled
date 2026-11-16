local parent = script.Parent
local parent2 = parent.Parent
local NotificationCardContext = require(parent.NotificationCardContext)

local parent3 = parent2.Parent
local React = require(parent3.React)
require(parent2.type)
local constants = require(parent2.constants)

local analyticsService = require(parent2.analytics.analyticsService)
local utils = parent2.utils
local toastNotificationHelper = require(utils.toastNotificationHelper)

local function NotificationCardProvider(props)
	local eventStream = analyticsService.EventStream
	local cardSize = {
		thumbnail = constants.CardSizeDefault.thumbnail,
		cardPadding = constants.Padding.DefaultCardPadding
	}

	if props.isCompact then
		cardSize.thumbnail = constants.CardSizeCompact.thumbnail
		cardSize.cardPadding = constants.Padding.CompactCardPadding
	end

	local cardTransparency

	if props.isCompact then
		cardTransparency = constants.CardTransparency.Compact
	else
		cardTransparency = constants.CardTransparency.Default
	end

	local function fn(p)
		toastNotificationHelper.fireEvent(eventStream, p)
	end
	return React.createElement(NotificationCardContext.Provider, {
		value = {
			state = props.state,
			cardSize = cardSize,
			handleActions = props.handleActions,
			sendEvent = fn,
			cardTransparency = cardTransparency,
			notificationReceivedTimestampMs = props.notificationReceivedTimestampMs,
			timers = props.timers,
			displayTimestampMs = props.displayTimestampMs
		}
	}, props.children)
end

return NotificationCardProvider
