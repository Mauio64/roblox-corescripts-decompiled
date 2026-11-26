local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")

local ConversationRowView = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/ConversationRowView")
local useConversationRowBindingPresentation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow/useConversationRowBindingPresentation")

local function ConversationRowBindingHost(p2)
	local v5 = useConversationRowBindingPresentation({ itemSignal = p2.itemSignal })

	if v5.hasConversation then
		return React.createElement(ConversationRowView, {
			itemSignal = p2.itemSignal,
			entryHeight = v5.entryHeight,
			pagePaddingLeft = v5.pagePaddingLeft,
			pagePaddingRight = v5.pagePaddingRight,
			testId = v5.testId,
			locatorTitle = v5.locatorTitle,
			title = v5.title,
			subtitleText = v5.subtitleText,
			timestampText = v5.timestampText,
			showSubscriptionBadge = v5.showSubscriptionBadge,
			showUnread = v5.showUnread,
			showSquadButton = v5.showSquadButton,
			showTimestamp = v5.showTimestamp,
			squadLocation = v5.squadLocation,
			rowRef = v5.rowRef,
			onRowActivated = v5.onRowActivated,
			onSquadActivated = v5.onSquadActivated,
			showBackground = v5.showBackground,
			debugCellValue = v5.debugCellValue
		})
	end

	return nil
end

return React.memo(ConversationRowBindingHost)
