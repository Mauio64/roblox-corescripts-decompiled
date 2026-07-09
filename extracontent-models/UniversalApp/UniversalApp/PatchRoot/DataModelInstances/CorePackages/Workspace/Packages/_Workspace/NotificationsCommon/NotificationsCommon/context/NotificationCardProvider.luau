local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local NotificationCardContext = require(scriptParent.NotificationCardContext)
local scriptParentParentParent = scriptParentParent.Parent
local React = require(scriptParentParentParent.React)

require(scriptParentParent.type)

local constants = require(scriptParentParent.constants)

local function NotificationCardProvider(t1: {[any]: any}) -- line: 24
	-- upvalues: constants (copy), React (copy), NotificationCardContext (copy)
	local t2 = {
		thumbnail = constants.CardSizeDefault.thumbnail,
		cardPadding = constants.Padding.DefaultCardPadding
	}

	if t1.isCompact then
		t2.thumbnail = constants.CardSizeCompact.thumbnail
		t2.cardPadding = constants.Padding.CompactCardPadding
	end

	local v10 = if not t1.isCompact then constants.CardTransparency.Default else constants.CardTransparency.Compact

	return React.createElement(NotificationCardContext.Provider, {
		value = {
			notificationPayload = t1.notificationPayload,
			state = t1.state,
			cardSize = t2,
			handleActions = t1.handleActions,
			openMetaActions = t1.openMetaActions,
			readOnly = t1.readOnly,
			cardTransparency = v10
		}
	}, t1.children)
end

return NotificationCardProvider
