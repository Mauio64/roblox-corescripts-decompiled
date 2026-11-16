local parent = script.Parent
local parent2 = parent.Parent

local MessageBus = require(parent2.MessageBus)
local messageBus = MessageBus.MessageBus
local t = require(parent2.t)
local ArgCheck = require(parent2.ArgCheck)

require(parent.LoggingProtocolTypes)
local AppCommonLib = require(parent2.AppCommonLib)
local callOnce = AppCommonLib.callOnce
local callOncePerDM = require(parent.callOncePerDM)
local Signal = AppCommonLib.Signal

game:DefineFastFlag("EnableTelemetryProtocol", false)

function getDomainName(): string
	if game:GetFastFlag("EnableTelemetryProtocol") then
		return "Telemetry"
	end

	return "Logging"
end

local telemetryBackends = {
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
local LoggingProtocol = {
	TelemetryBackends = telemetryBackends,
	StandardizedFields = {
		addPlaceId = "addPlaceId",
		addUniverseId = "addUniverseId",
		addPlaceInstanceId = "addPlaceInstanceId",
		addSessionId = "addSessionId",
		addOsInfo = "addOSInfo"
	},
	LOG_EVENT_WITH_TIMESTAMP_DESCRIPTOR = {
		fid = messageBus.getMessageId(getDomainName(), "logEventWithTimestamp"),
		validateParams = strictInterface
	},
	GET_TIMESTAMP_DESCRIPTOR = {
		fid = messageBus.getMessageId(getDomainName(), "getTimestamp"),
		validateParams = t.table
	},
	LOG_EVENT_FROM_LUA_DESCRIPTOR = {
		fid = messageBus.getMessageId(getDomainName(), "logEventFromLua"),
		validateParams = t.interface({
			eventType = t.string,
			config = t.optional(t.strictInterface({
				eventName = t.string,
				backends = t.array(t.valueOf(telemetryBackends)),
				throttlingPercentage = t.optional(t.number),
				lastUpdated = t.optional(t.array(t.integer)),
				description = t.optional(t.string),
				links = t.optional(t.string)
			})),
			data = t.optional(t.table)
		})
	}
}

LoggingProtocol.__index = LoggingProtocol

function LoggingProtocol.new(p)
	local v = {
		messageBus = p or messageBus,
		durationLoggerSignal = Signal.new()
	}

	setmetatable(v, LoggingProtocol)
	return v
end

function LoggingProtocol.setDurationLoggerListener(p, callback)
	return p.durationLoggerSignal:connect(callback)
end

function LoggingProtocol:logEventWithTimestamp(eventName: string, timestamp: number, metadata)
	ArgCheck.isType(eventName, "string", "eventName")
	ArgCheck.isType(timestamp, "number", "timestamp")
	self.messageBus.call(self.LOG_EVENT_WITH_TIMESTAMP_DESCRIPTOR, {
		eventName = eventName,
		timestamp = timestamp,
		metadata = metadata
	})
	self.durationLoggerSignal:fire(eventName)
end

function LoggingProtocol:logEvent(p: string, p2)
	ArgCheck.isType(p, "string", "eventName")
	self:logEventWithTimestamp(p, 0, p2)
end

function LoggingProtocol:logEventOnce(p: string, p2)
	ArgCheck.isType(p, "string", "eventName")

	if game:DefineFastFlag("LuaAppSendTTIEventsPerDM", false) then
		callOncePerDM(string.format("logging_protocol_key-%s", p), function()
			self:logEvent(p, p2)
		end)
	else
		callOnce(string.format("logging_protocol_key-%s", p), function()
			self:logEvent(p, p2)
		end)
	end
end

function LoggingProtocol.getTimestamp(p)
	return p.messageBus.call(p.GET_TIMESTAMP_DESCRIPTOR, {})
end

function LoggingProtocol.logRobloxTelemetryCounter(p, config, incrementValue: number?, customFields)
	p.messageBus.call(p.LOG_EVENT_FROM_LUA_DESCRIPTOR, {
		eventType = "RobloxTelemetryCounter",
		config = config,
		data = incrementValue and { incrementValue = incrementValue, customFields = customFields } or customFields and {
			customFields = customFields
		} or nil
	})
end

function LoggingProtocol.logRobloxTelemetryStat(p, config, statValue: number, customFields)
	p.messageBus.call(p.LOG_EVENT_FROM_LUA_DESCRIPTOR, {
		eventType = "RobloxTelemetryStat",
		config = config,
		data = { statValue = statValue, customFields = customFields }
	})
end

function LoggingProtocol.logRobloxTelemetryEvent(p, config, standardizedFields, customFields, eventContext: string?)
	p.messageBus.call(p.LOG_EVENT_FROM_LUA_DESCRIPTOR, {
		eventType = "RobloxTelemetry",
		config = config,
		data = {
			standardizedFields = standardizedFields,
			customFields = customFields,
			eventContext = eventContext
		}
	})
end

function LoggingProtocol.logEphemeralCounterEvent(p, config, incrementValue: number?)
	p.messageBus.call(p.LOG_EVENT_FROM_LUA_DESCRIPTOR, {
		eventType = "EphemeralCounter",
		config = config,
		data = incrementValue and { incrementValue = incrementValue } or nil
	})
end

function LoggingProtocol.logEphemeralStatEvent(p, config, statValue: number)
	p.messageBus.call(p.LOG_EVENT_FROM_LUA_DESCRIPTOR, {
		eventType = "EphemeralStat",
		config = config,
		data = { statValue = statValue }
	})
end

LoggingProtocol.default = LoggingProtocol.new()

return LoggingProtocol
