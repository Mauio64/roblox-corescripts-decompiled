local SuggestionType = require(script.Parent.Types).SuggestionType
local t1 = {
	SuggestionType.Message,
	SuggestionType.GameCard
}

return {
	MAX_SUGGESTIONS = 4,
	SUGGESTION_TYPES = t1
}
