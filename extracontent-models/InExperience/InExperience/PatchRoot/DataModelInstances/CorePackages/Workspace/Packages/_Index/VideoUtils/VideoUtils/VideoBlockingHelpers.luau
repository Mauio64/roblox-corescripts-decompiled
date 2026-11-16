return {
	VideoBlockingTelemetryConfig = {
		eventName = "EdpVideoPreviewBlockingStatus",
		backends = { "Points", "EventIngest" },
		lastUpdated = { 26, 3, 25 },
		description = "Telemetry about whether or not the video is blocked by manufacturer/device/max memory",
		throttlingPercentage = game:DefineFastInt("VideoBlockingTelemetryThrottleHundredthsPercent", 10000)
	},
	isInPipeDenyList = function(value: string?, value2: string?): boolean
		if not value or not value2 or value2 == "" then
			return false
		end

		for k in value2:gmatch("([^|]+)") do
			if typeof(k) == "string" and string.lower(k) == string.lower(value) then
				return true
			end
		end

		return false
	end
}
