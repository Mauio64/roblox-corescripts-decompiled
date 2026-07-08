return {
	VideoBlockingTelemetryConfig = {
		eventName = "EdpVideoPreviewBlockingStatus",
		description = "Telemetry about whether or not the video is blocked by manufacturer/device/max memory",
		backends = {
			"Points",
			"EventIngest"
		},
		lastUpdated = {
			26,
			3,
			25
		},
		throttlingPercentage = game:DefineFastInt("VideoBlockingTelemetryThrottleHundredthsPercent", 10000)
	},
	isInPipeDenyList = function(s1: string?, s2: string?) -- line: 15
		if not s1 or (not s2 or s2 == "") then
			return false
		end

		for match in s2:gmatch("([^|]+)") do
			if typeof(match) == "string" and string.lower(match) == string.lower(s1) then
				return true
			end
		end

		return false
	end
}
