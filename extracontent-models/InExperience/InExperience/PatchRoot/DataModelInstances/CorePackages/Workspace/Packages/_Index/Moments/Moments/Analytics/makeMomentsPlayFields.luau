local function makeMomentsPlayFields(data)
	return {
		client_event_timestamp_ms = data.clientEventTimestampMs,
		feedItemId = data.feedItemId,
		momentsPlayIntentId = data.momentsPlayIntentId,
		viewId = data.viewId
	}
end

return makeMomentsPlayFields
