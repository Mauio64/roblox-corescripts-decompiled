local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SmartSuggestions/Types")
local SmartSuggestionsChipRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SmartSuggestions/SmartSuggestionsChipRow")
local useSmartSuggestions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SmartSuggestions/useSmartSuggestions")

local function SmartSuggestionsChipRowContainer(props)
	local v5 = useSmartSuggestions(props.conversationId, props.sendMessage, props.sendGameLinkChatMessage)
	local suggestions = props.suggestions or v5.suggestions

	if #suggestions == 0 or v5.areSuggestionsDismissed then
		return nil
	end

	return React.createElement(SmartSuggestionsChipRow, {
		LayoutOrder = props.LayoutOrder,
		suggestions = suggestions,
		onActivated = v5.onActivated
	})
end

return React.memo(SmartSuggestionsChipRowContainer)
