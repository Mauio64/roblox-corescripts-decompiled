local thresholds2 = { warn = 30, error = 50 }

local v = nil

local function getFieldSeverity(p: string, value): nil | string
	local v2 = v[p]
	local thresholds = v2 and v2.thresholds

	if not thresholds or type(value) ~= "number" then
		return nil
	end

	if thresholds.error <= value then
		return "error"
	end

	return if thresholds.warn <= value then "warn" else "ok"
end

v = {
	rttMs = {
		label = "Round-trip time",
		unit = "ms",
		plottable = true,
		thresholds = { warn = 150, error = 300 },
		group = "Connection"
	},
	incomingStreams = { label = "Incoming streams", group = "Connection" },
	outgoingStreams = { label = "Outgoing streams", group = "Connection" },
	incomingJitterMs = {
		label = "Incoming jitter",
		unit = "ms",
		plottable = true,
		thresholds = thresholds2,
		group = "Incoming"
	},
	outgoingJitterMs = {
		label = "Outgoing jitter",
		unit = "ms",
		plottable = true,
		thresholds = thresholds2,
		group = "Outgoing"
	},
	incomingPackets = { label = "Incoming packets", group = "Incoming" },
	outgoingPackets = { label = "Outgoing packets", group = "Outgoing" },
	incomingPacketsLost = { label = "Incoming packets lost", group = "Incoming" },
	outgoingPacketsLost = { label = "Outgoing packets lost", group = "Outgoing" },
	incomingPacketsDiscarded = { label = "Incoming packets discarded", group = "Incoming" },
	outgoingPacketsDiscarded = { label = "Outgoing packets discarded", group = "Outgoing" },
	jitterBufferDelayMs = {
		label = "Jitter buffer delay",
		unit = "ms",
		thresholds = { warn = 60, error = 150 },
		group = "Incoming"
	},
	incomingFecPackets = { label = "Incoming FEC packets", group = "Incoming" },
	incomingFecPacketsDiscarded = { label = "Incoming FEC packets discarded", group = "Incoming" },
	totalConcealmentEvents = { label = "Concealment events", group = "Incoming" },
	incomingBytes = { label = "Incoming bytes", group = "Incoming" },
	outgoingBytes = { label = "Outgoing bytes", group = "Outgoing" },
	lastPublisherAudioLevelDbov = {
		label = "Publisher audio level",
		unit = "dBov",
		group = "Outgoing"
	},
	lastSubscriberAudioLevelDbov = {
		label = "Subscriber audio level",
		unit = "dBov",
		group = "Incoming"
	},
	incomingBitrateKbps = {
		label = "Incoming bitrate",
		unit = "kbps",
		plottable = true,
		group = "Incoming"
	},
	outgoingBitrateKbps = {
		label = "Outgoing bitrate",
		unit = "kbps",
		plottable = true,
		group = "Outgoing"
	},
	outgoingCodec = { label = "Outgoing codec", group = "Outgoing" },
	incomingLossPercent = {
		label = "Incoming loss",
		unit = "%",
		plottable = true,
		thresholds = { warn = 3, error = 1e999 },
		group = "Incoming"
	},
	getFieldSeverity = getFieldSeverity
}

return v
