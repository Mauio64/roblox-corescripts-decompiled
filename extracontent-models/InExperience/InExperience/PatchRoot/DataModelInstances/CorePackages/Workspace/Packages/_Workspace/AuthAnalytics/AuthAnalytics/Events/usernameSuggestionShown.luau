local parent = script.Parent.Parent
local checkAndSendEvent = require(parent.Utils.checkAndSendEvent)

return function(p: string, state: string, list, field: string)
	assert(type(list) == "table", "Expected suggestions to be a table")

	checkAndSendEvent(p, "usernameSuggestionShown", {
		state = state,
		suggestions = `[{table.concat(list, ",")}]`,
		field = field
	})
end
