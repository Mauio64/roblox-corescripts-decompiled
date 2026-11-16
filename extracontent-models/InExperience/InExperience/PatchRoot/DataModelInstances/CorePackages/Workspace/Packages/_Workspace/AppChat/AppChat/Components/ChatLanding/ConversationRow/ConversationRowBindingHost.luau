local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
require(parent.Signals)

local ConversationRowView = require(script.Parent.ConversationRowView)
local useConversationRowBindingPresentation = require(script.Parent.useConversationRowBindingPresentation)

local function ConversationRowBindingHost(p)
	local v = useConversationRowBindingPresentation({ itemSignal = p.itemSignal })

	if v.hasConversation then
		return React.createElement(ConversationRowView, {
			itemSignal = p.itemSignal,
			entryHeight = v.entryHeight,
			pagePaddingLeft = v.pagePaddingLeft,
			pagePaddingRight = v.pagePaddingRight,
			testId = v.testId,
			locatorTitle = v.locatorTitle,
			title = v.title,
			subtitleText = v.subtitleText,
			timestampText = v.timestampText,
			showSubscriptionBadge = v.showSubscriptionBadge,
			showUnread = v.showUnread,
			showSquadButton = v.showSquadButton,
			showTimestamp = v.showTimestamp,
			squadLocation = v.squadLocation,
			rowRef = v.rowRef,
			onRowActivated = v.onRowActivated,
			onSquadActivated = v.onSquadActivated,
			showBackground = v.showBackground,
			debugCellValue = v.debugCellValue
		})
	end

	return nil
end

return React.memo(ConversationRowBindingHost)
