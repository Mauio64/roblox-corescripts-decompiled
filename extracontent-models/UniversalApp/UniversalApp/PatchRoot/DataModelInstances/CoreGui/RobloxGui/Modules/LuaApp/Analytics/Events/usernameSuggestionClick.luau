return function(p1, s1: string, s2: string, s3: string, s4: string) -- line: 4
	assert(type(s1) == "string", "Expected eventContext to be a string")
	assert(type(s2) == "string", "Expected buttonName to be a string")
	assert(type(s3) == "string", "Expected userField to be a string")
	assert(type(s4) == "string", "Expected suggestion to be a string")
	p1:setRBXEventStream(s1, "buttonClick", {
		btn = s2,
		userField = s3,
		suggestion = s4
	})
end
