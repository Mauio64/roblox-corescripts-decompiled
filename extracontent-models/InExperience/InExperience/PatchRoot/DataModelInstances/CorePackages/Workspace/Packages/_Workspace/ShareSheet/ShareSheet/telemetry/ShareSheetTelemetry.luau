local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("ShareSheet").Parent
local EventIngest = require(Parent.LoggingProtocol).TelemetryBackends.EventIngest
local v4 = game:DefineFastInt("ShareSheetTelemetryThrottleHundredthsPercent", 10000)
local t1 = {
	shareSheetOpened = {
		eventName = "shareSheetOpened",
		description = "Share sheet was opened",
		backends = { EventIngest },
		throttlingPercentage = v4,
		lastUpdated = {
			2025,
			7,
			22
		}
	},
	shareSheetLinkCopied = {
		eventName = "shareSheetLinkCopied",
		description = "Link was copied from share sheet",
		backends = { EventIngest },
		throttlingPercentage = v4,
		lastUpdated = {
			2025,
			7,
			22
		}
	},
	shareSheetMessageSent = {
		eventName = "shareSheetMessageSent",
		description = "Message was sent from share sheet",
		backends = { EventIngest },
		throttlingPercentage = v4,
		lastUpdated = {
			2025,
			7,
			22
		}
	}
}
local t2 = {
	"addPlaceId",
	"addUniverseId",
	"addPlaySessionId",
	"addSessionInfo"
}

return {
	logShareSheetOpened = function(t3: {[any]: any}) -- line: 48
		-- upvalues: TelemetryService (copy), t1 (copy), t2 (copy)
		TelemetryService:LogEvent(t1.shareSheetOpened, {
			standardizedFields = t2,
			customFields = t3
		})
	end,
	logShareSheetLinkCopied = function(t4: {[any]: any}) -- line: 55
		-- upvalues: TelemetryService (copy), t1 (copy), t2 (copy)
		TelemetryService:LogEvent(t1.shareSheetLinkCopied, {
			standardizedFields = t2,
			customFields = t4
		})
	end,
	logShareSheetMessageSent = function(t5: {[any]: any}) -- line: 62
		-- upvalues: TelemetryService (copy), t1 (copy), t2 (copy)
		TelemetryService:LogEvent(t1.shareSheetMessageSent, {
			standardizedFields = t2,
			customFields = t5
		})
	end
}
