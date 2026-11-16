return function(object, value, value2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected appStage to be a string")

	object:setRBXEventStream(value, "appStageLoaded", { stage = value2 })
end
