local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local NotificationCardContext = require(scriptParent.NotificationCardContext)
local scriptParentParentParent = scriptParentParent.Parent
local React = require(scriptParentParentParent.React)

require(scriptParentParent.type)

local constants = require(scriptParentParent.constants)
local analyticsService = require(scriptParentParent.analytics.analyticsService)
local utils = scriptParentParent.utils
local toastNotificationHelper = require(utils.toastNotificationHelper)

local function NotificationCardProvider(t1: {[any]: any}) -- line: 23
	-- upvalues: analyticsService (copy), constants (copy), toastNotificationHelper (copy), React (copy), NotificationCardContext (copy)
	local EventStream = analyticsService.EventStream
	local t2 = {
		thumbnail = constants.CardSizeDefault.thumbnail,
		cardPadding = constants.Padding.DefaultCardPadding
	}

	if t1.isCompact then
		t2.thumbnail = constants.CardSizeCompact.thumbnail
		t2.cardPadding = constants.Padding.CompactCardPadding
	end

	local v14 = if not t1.isCompact then constants.CardTransparency.Default else constants.CardTransparency.Compact

	return React.createElement(NotificationCardContext.Provider, {
		value = {
			state = t1.state,
			cardSize = t2,
			handleActions = t1.handleActions,
			sendEvent = function(p1) -- line: 36
				-- upvalues: toastNotificationHelper (copy), EventStream (copy)
				toastNotificationHelper.fireEvent(EventStream, p1)
			end,
			cardTransparency = v14,
			notificationReceivedTimestampMs = t1.notificationReceivedTimestampMs,
			timers = t1.timers,
			displayTimestampMs = t1.displayTimestampMs
		}
	}, t1.children)
end

return NotificationCardProvider
