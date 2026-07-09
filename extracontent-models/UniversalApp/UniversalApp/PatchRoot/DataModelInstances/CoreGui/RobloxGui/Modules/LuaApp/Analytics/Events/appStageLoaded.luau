return function(p1, p2, p3) -- line: 4
	assert(type(p2) == "string", "Expected eventContext to be a string")
	assert(type(p3) == "string", "Expected appStage to be a string")
	p1:setRBXEventStream(p2, "appStageLoaded", {
		stage = p3
	})
end
