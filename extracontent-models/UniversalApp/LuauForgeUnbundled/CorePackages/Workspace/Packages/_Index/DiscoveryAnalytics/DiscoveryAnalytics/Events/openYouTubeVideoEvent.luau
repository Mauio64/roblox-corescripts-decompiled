return function(object, value, p2, p3, p4, p5)
	assert(type(value) == "string", "Expected eventContext to be a string")

	object:setRBXEventStream(value, "openYouTubeVideo", {
		videoTitle = p2,
		videoID = p3,
		universeId = p4,
		interactionType = p5
	})
end
