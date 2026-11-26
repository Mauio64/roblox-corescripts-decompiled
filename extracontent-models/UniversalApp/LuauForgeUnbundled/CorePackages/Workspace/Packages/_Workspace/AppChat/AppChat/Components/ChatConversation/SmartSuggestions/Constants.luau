local suggestionType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/SmartSuggestions/Types").SuggestionType

return {
	SUGGESTION_TYPES = { suggestionType.Message, suggestionType.GameCard, suggestionType.StartParty },
	MAX_SUGGESTIONS = 4
}
