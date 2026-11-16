local Types = require(script.Parent.Types)

local SuggestionType = Types.SuggestionType

return {
	SUGGESTION_TYPES = { SuggestionType.Message, SuggestionType.GameCard, SuggestionType.StartParty },
	MAX_SUGGESTIONS = 4
}
