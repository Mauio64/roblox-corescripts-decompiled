local Action = require(script.Parent.Parent.Action)

return Action(script.Name, function(waitingForRecording, value)
	return {
		waitingForRecording = waitingForRecording,
		lastFileOutputLocation = value or ""
	}
end)
