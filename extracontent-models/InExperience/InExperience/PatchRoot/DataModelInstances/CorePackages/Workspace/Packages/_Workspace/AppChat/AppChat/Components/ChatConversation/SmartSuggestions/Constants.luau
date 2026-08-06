local SuggestionType = require(script.Parent.Types).SuggestionType
local t1 = {
	SuggestionType.Message,
	SuggestionType.GameCard,
	SuggestionType.StartParty
}

return {
	MAX_SUGGESTIONS = 4,
	SUGGESTION_TYPES = t1
}
