local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/LoggingProtocol/MessageBus").MessageBus
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/LoggingProtocol/t")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/LoggingProtocol/ArgCheck")

require("@game/CorePackages/Workspace/Packages/_Workspace/LoggingProtocol/LoggingProtocol/LoggingProtocolTypes")
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/LoggingProtocol/AppCommonLib")
local callOnce = AppCommonLib.callOnce
local callOncePerDM = require("@game/CorePackages/Workspace/Packages/_Workspace/LoggingProtocol/LoggingProtocol/callOncePerDM")
local signal = AppCommonLib.Signal

game:DefineFastFlag("EnableTelemetryProtocol", false)

function LUAUFORGE_MODULE_GLOBALS_zQ_getDomainName(): string
	if game:GetFastFlag("EnableTelemetryProtocol") then
		return "Telemetry"
	end

	return "Logging"
end

local v5 = {
	UNSPECIFIED = "UNSPECIFIED",
	EventIngest = "EventIngest",
	Points = "Points",
	EphemeralCounter = "EphemeralCounter",
	EphemeralStat = "EphemeralStat",
	Counter = "RobloxTelemetryCounter",
	Stats = "RobloxTelemetryStat"
}

local strictInterface = t.strictInterface({
	eventName = t.string,
	timestamp = t.optional(t.number),
	metadata = t.optional(t.keys(t.string))
})
local v6 = {
	TelemetryBackends = v5,
	StandardizedFields = {
		addPlaceId = "addPlaceId",
		addUniverseId = "addUniverseId",
		addPlaceInstanceId = "addPlaceInstanceId",
		addSessionId = "addSessionId",
		addOsInfo = "addOSInfo"
	},
	LOG_EVENT_WITH_TIMESTAMP_DESCRIPTOR = {
		fid = messageBus.getMessageId(LUAUFORGE_MODULE_GLOBALS_zQ_getDomainName(), "logEventWithTimestamp"),
		validateParams = strictInterface
	},
	GET_TIMESTAMP_DESCRIPTOR = {
		fid = messageBus.getMessageId(LUAUFORGE_MODULE_GLOBALS_zQ_getDomainName(), "getTimestamp"),
		validateParams = t.table
	},
	LOG_EVENT_FROM_LUA_DESCRIPTOR = {
		fid = messageBus.getMessageId(LUAUFORGE_MODULE_GLOBALS_zQ_getDomainName(), "logEventFromLua"),
		validateParams = t.interface({
			eventType = t.string,
			config = t.optional(t.strictInterface({
				eventName = t.string,
				backends = t.array(t.valueOf(v5)),
				throttlingPercentage = t.optional(t.number),
				lastUpdated = t.optional(t.array(t.integer)),
				description = t.optional(t.string),
				links = t.optional(t.string)
			})),
			data = t.optional(t.table)
		})
	}
}

v6.__index = v6

function v6.new(p2)
	local v7 = {
		messageBus = p2 or messageBus,
		durationLoggerSignal = signal.new()
	}

	setmetatable(v7, v6)
	return v7
end

function v6:setDurationLoggerListener(p3)
	return self.durationLoggerSignal:connect(p3)
end

function v6:logEventWithTimestamp(p2, p3, p4)
	ArgCheck.isType(p2, "string", "eventName")
	ArgCheck.isType(p3, "number", "timestamp")
	self.messageBus.call(self.LOG_EVENT_WITH_TIMESTAMP_DESCRIPTOR, {
		eventName = p2,
		timestamp = p3,
		metadata = p4
	})
	self.durationLoggerSignal:fire(p2)
end

function v6:logEvent(p2, p3)
	ArgCheck.isType(p2, "string", "eventName")
	self:logEventWithTimestamp(p2, 0, p3)
end

function v6:logEventOnce(p2, p3)
	ArgCheck.isType(p2, "string", "eventName")

	if game:DefineFastFlag("LuaAppSendTTIEventsPerDM", false) then
		callOncePerDM(string.format("logging_protocol_key-%s", p2), function()
			self:logEvent(p2, p3)
		end)
	else
		callOnce(string.format("logging_protocol_key-%s", p2), function()
			self:logEvent(p2, p3)
		end)
	end
end

function v6.getTimestamp(p2)
	return p2.messageBus.call(p2.GET_TIMESTAMP_DESCRIPTOR, {})
end

function v6:logRobloxTelemetryCounter(p3, p4, p5)
	self.messageBus.call(self.LOG_EVENT_FROM_LUA_DESCRIPTOR, {
		eventType = "RobloxTelemetryCounter",
		config = p3,
		data = p4 and { incrementValue = p4, customFields = p5 } or p5 and {
			customFields = p5
		} or nil
	})
end

function v6:logRobloxTelemetryStat(p3, p4, p5)
	self.messageBus.call(self.LOG_EVENT_FROM_LUA_DESCRIPTOR, {
		eventType = "RobloxTelemetryStat",
		config = p3,
		data = { statValue = p4, customFields = p5 }
	})
end

function v6:logRobloxTelemetryEvent(p3, p4, p5, p6)
	self.messageBus.call(self.LOG_EVENT_FROM_LUA_DESCRIPTOR, {
		eventType = "RobloxTelemetry",
		config = p3,
		data = { standardizedFields = p4, customFields = p5, eventContext = p6 }
	})
end

function v6:logEphemeralCounterEvent(p3, p4)
	self.messageBus.call(self.LOG_EVENT_FROM_LUA_DESCRIPTOR, {
		eventType = "EphemeralCounter",
		config = p3,
		data = p4 and { incrementValue = p4 } or nil
	})
end

function v6.logEphemeralStatEvent(p2, p3, p4)
	p2.messageBus.call(p2.LOG_EVENT_FROM_LUA_DESCRIPTOR, {
		eventType = "EphemeralStat",
		config = p3,
		data = { statValue = p4 }
	})
end

v6.default = v6.new()

return v6
