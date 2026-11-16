local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)

require(script.Parent.Types)
local SmartSuggestionsChipRow = require(script.Parent.SmartSuggestionsChipRow)
local useSmartSuggestions = require(script.Parent.useSmartSuggestions)

local function SmartSuggestionsChipRowContainer(props)
	local v = useSmartSuggestions(props.conversationId, props.sendMessage, props.sendGameLinkChatMessage)
	local suggestions = props.suggestions or v.suggestions

	if #suggestions == 0 or v.areSuggestionsDismissed then
		return nil
	end

	return React.createElement(SmartSuggestionsChipRow, {
		LayoutOrder = props.LayoutOrder,
		suggestions = suggestions,
		onActivated = v.onActivated
	})
end

return React.memo(SmartSuggestionsChipRowContainer)
