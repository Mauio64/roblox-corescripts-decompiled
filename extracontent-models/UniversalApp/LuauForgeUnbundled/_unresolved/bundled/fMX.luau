return function(object, value, value2, list, value3)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected state to be a string")
	assert(type(list) == "table", "Expected suggestions to be a table")
	assert(type(value3) == "string", "Expected suggestion to be a string")

	object:sendEventDeferred(value, "usernameSuggestionShown", {
		state = value2,
		suggestions = `[{table.concat(list, ",")}]`,
		field = value3
	})
end
