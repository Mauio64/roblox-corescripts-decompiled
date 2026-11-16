local parent = script.Parent
local parent2 = parent.Parent
local NotificationCardContext = require(parent.NotificationCardContext)

local parent3 = parent2.Parent
local React = require(parent3.React)
require(parent2.type)
local constants = require(parent2.constants)

local function NotificationCardProvider(props)
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

	return React.createElement(NotificationCardContext.Provider, {
		value = {
			notificationPayload = props.notificationPayload,
			state = props.state,
			cardSize = cardSize,
			handleActions = props.handleActions,
			openMetaActions = props.openMetaActions,
			readOnly = props.readOnly,
			cardTransparency = cardTransparency
		}
	}, props.children)
end

return NotificationCardProvider
