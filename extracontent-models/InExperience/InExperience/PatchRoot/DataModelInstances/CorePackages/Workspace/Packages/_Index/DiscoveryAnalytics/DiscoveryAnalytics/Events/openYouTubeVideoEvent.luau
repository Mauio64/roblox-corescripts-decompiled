return function(object, value, videoTitle, videoID, universeId: string?, interactionType: string?)
	assert(type(value) == "string", "Expected eventContext to be a string")

	object:setRBXEventStream(value, "openYouTubeVideo", {
		videoTitle = videoTitle,
		videoID = videoID,
		universeId = universeId,
		interactionType = interactionType
	})
end
