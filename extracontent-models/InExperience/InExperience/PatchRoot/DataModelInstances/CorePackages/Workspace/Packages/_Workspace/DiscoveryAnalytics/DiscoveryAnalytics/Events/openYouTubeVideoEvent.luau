return function(p1, p2, p3, p4, s1: string?, s2: string?) -- line: 3
	assert(type(p2) == "string", "Expected eventContext to be a string")
	p1:setRBXEventStream(p2, "openYouTubeVideo", {
		videoTitle = p3,
		videoID = p4,
		universeId = s1,
		interactionType = s2
	})
end
