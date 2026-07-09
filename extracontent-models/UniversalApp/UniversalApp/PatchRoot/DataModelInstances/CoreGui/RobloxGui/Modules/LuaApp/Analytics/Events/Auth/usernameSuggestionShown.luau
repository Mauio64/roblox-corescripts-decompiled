return function(p1, s1: string, s2: string, t1: {[any]: any}, s3: string) -- line: 4
	assert(type(s1) == "string", "Expected eventContext to be a string")
	assert(type(s2) == "string", "Expected state to be a string")
	assert(type(t1) == "table", "Expected suggestions to be a table")
	assert(type(s3) == "string", "Expected suggestion to be a string")
	p1:sendEventDeferred(s1, "usernameSuggestionShown", {
		state = s2,
		suggestions = `[{ table.concat(t1, ",") }]`,
		field = s3
	})
end
