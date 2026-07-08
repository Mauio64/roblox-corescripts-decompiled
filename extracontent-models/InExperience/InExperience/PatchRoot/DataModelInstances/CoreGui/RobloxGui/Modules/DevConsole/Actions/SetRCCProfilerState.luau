return require(script.Parent.Parent.Action)(script.Name, function(p1, p2) -- line: 4
	return {
		waitingForRecording = p1,
		lastFileOutputLocation = p2 or ""
	}
end)
