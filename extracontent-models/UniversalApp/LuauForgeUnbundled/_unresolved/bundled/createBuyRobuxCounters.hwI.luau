local v5 = { "addOSInfo", "addSessionInfo", "addSessionId" }

local function createBuyRobuxCounters(object)
	local function publish(p2, options)
		object:LogCounter({
			eventName = `BuyRobuxSdui_{p2}`,
			backends = { "RobloxTelemetryCounter" },
			lastUpdated = { 26, 10, 7 },
			description = "SDUI Buy Robux page counter mirroring web robuxRedesign observability"
		}, {
			standardizedFields = v5,
			customFields = options or {}
		}, 1)
	end

	local function withSeverity(severity, options, p2)
		local clone = table.clone(options or {})
		clone.severity = severity

		if p2 ~= nil then
			clone.errorType = typeof(p2)
		end

		return clone
	end

	return {
		trackCounter = publish,
		trackError = function(p2, options, p3)
			local clone = table.clone(options or {})
			clone.severity = "error"

			if p3 ~= nil then
				clone.errorType = typeof(p3)
			end

			publish(p2, clone)
		end,
		trackCriticalError = function(p2, options, p3)
			local clone = table.clone(options or {})
			clone.severity = "critical"

			if p3 ~= nil then
				clone.errorType = typeof(p3)
			end

			publish(p2, clone)
		end
	}
end

return createBuyRobuxCounters
