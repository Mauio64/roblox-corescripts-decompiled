local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local MessageBus = require(scriptParentParent.MessageBus).MessageBus
local t = require(scriptParentParent.t)
local ArgCheck = require(scriptParentParent.ArgCheck)

require(scriptParent.LoggingProtocolTypes)

local AppCommonLib = require(scriptParentParent.AppCommonLib)
local callOnce = AppCommonLib.callOnce
local callOncePerDM = require(scriptParent.callOncePerDM)
local Signal = AppCommonLib.Signal

game:DefineFastFlag("EnableTelemetryProtocol", false)

function getDomainName() -- line: 82
	if game:GetFastFlag("EnableTelemetryProtocol") then
		return "Telemetry"
	end

	return "Logging"
end

local t1 = {
	UNSPECIFIED = "UNSPECIFIED",
	EventIngest = "EventIngest",
	Points = "Points",
	EphemeralCounter = "EphemeralCounter",
	EphemeralStat = "EphemeralStat",
	Counter = "RobloxTelemetryCounter",
	Stats = "RobloxTelemetryStat"
}
local t2 = {
	addPlaceId = "addPlaceId",
	addUniverseId = "addUniverseId",
	addPlaceInstanceId = "addPlaceInstanceId",
	addSessionId = "addSessionId",
	addOsInfo = "addOSInfo"
}
local v12 = t.strictInterface({
	eventName = t.string,
	timestamp = t.optional(t.number),
	metadata = t.optional(t.keys(t.string))
})
local t3 = {
	TelemetryBackends = t1,
	StandardizedFields = t2,
	LOG_EVENT_WITH_TIMESTAMP_DESCRIPTOR = {
		fid = MessageBus.getMessageId(getDomainName(), "logEventWithTimestamp"),
		validateParams = v12
	},
	GET_TIMESTAMP_DESCRIPTOR = {
		fid = MessageBus.getMessageId(getDomainName(), "getTimestamp"),
		validateParams = t.table
	},
	LOG_EVENT_FROM_LUA_DESCRIPTOR = {
		fid = MessageBus.getMessageId(getDomainName(), "logEventFromLua"),
		validateParams = t.interface({
			eventType = t.string,
			config = t.optional(t.strictInterface({
				eventName = t.string,
				backends = t.array(t.valueOf(t1)),
				throttlingPercentage = t.optional(t.number),
				lastUpdated = t.optional(t.array(t.integer)),
				description = t.optional(t.string),
				links = t.optional(t.string)
			})),
			data = t.optional(t.table)
		})
	}
}

t3.__index = t3

function t3.new(p1) -- line: 150
	-- upvalues: MessageBus (copy), Signal (copy), t3 (copy)
	local t4 = {
		messageBus = p1 or MessageBus,
		durationLoggerSignal = Signal.new()
	}

	setmetatable(t4, t3)

	return t4
end
function t3.setDurationLoggerListener(t5: {[any]: any}, p2: ((...any) -> ...any)) -- line: 159
	return t5.durationLoggerSignal:connect(p2)
end
function t3.logEventWithTimestamp(t6: {[any]: any}, s1: string, n1: number, p3) -- line: 163
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(s1, "string", "eventName")
	ArgCheck.isType(n1, "number", "timestamp")

	local t7 = {
		eventName = s1,
		timestamp = n1,
		metadata = p3
	}

	t6.messageBus.call(t6.LOG_EVENT_WITH_TIMESTAMP_DESCRIPTOR, t7)
	t6.durationLoggerSignal:fire(s1)
end
function t3.logEvent(t8: {[any]: any}, s2: string, p4) -- line: 175
	-- upvalues: ArgCheck (copy)
	ArgCheck.isType(s2, "string", "eventName")
	t8:logEventWithTimestamp(s2, 0, p4)
end
function t3.logEventOnce(t9: {[any]: any}, s3: string, p5) -- line: 180
	-- upvalues: ArgCheck (copy), callOncePerDM (copy), callOnce (copy)
	ArgCheck.isType(s3, "string", "eventName")

	if game:DefineFastFlag("LuaAppSendTTIEventsPerDM", false) then
		callOncePerDM(string.format("logging_protocol_key-%s", s3), function() -- line: 184
			-- upvalues: t9 (copy), s3 (copy), p5 (copy)
			t9:logEvent(s3, p5)
		end)

		return
	end

	callOnce(string.format("logging_protocol_key-%s", s3), function() -- line: 188
		-- upvalues: t9 (copy), s3 (copy), p5 (copy)
		t9:logEvent(s3, p5)
	end)
end
function t3.getTimestamp(p6) -- line: 195
	return p6.messageBus.call(p6.GET_TIMESTAMP_DESCRIPTOR, {})
end
function t3.logRobloxTelemetryCounter(t10: {[any]: any}, p7, n2: number?, p8) -- line: 199
	local t11 = {
		eventType = "RobloxTelemetryCounter",
		config = p7,
		data = if not n2 then if not p8 then nil else {
			customFields = p8
		} else {
			incrementValue = n2,
			customFields = p8
		}
	}

	t10.messageBus.call(t10.LOG_EVENT_FROM_LUA_DESCRIPTOR, t11)
end
function t3.logRobloxTelemetryStat(t12: {[any]: any}, p9, n3: number, p10) -- line: 221
	local t13 = {
		eventType = "RobloxTelemetryStat",
		config = p9,
		data = {
			statValue = n3,
			customFields = p10
		}
	}

	t12.messageBus.call(t12.LOG_EVENT_FROM_LUA_DESCRIPTOR, t13)
end
function t3.logRobloxTelemetryEvent(t14: {[any]: any}, p11, p12, p13, s4: string?) -- line: 237
	local t15 = {
		eventType = "RobloxTelemetry",
		config = p11,
		data = {
			standardizedFields = p12,
			customFields = p13,
			eventContext = s4
		}
	}

	t14.messageBus.call(t14.LOG_EVENT_FROM_LUA_DESCRIPTOR, t15)
end
function t3.logEphemeralCounterEvent(t16: {[any]: any}, p14, n4: number?) -- line: 255
	local t17 = {
		eventType = "EphemeralCounter",
		config = p14,
		data = if not n4 then nil else {
			incrementValue = n4
		}
	}

	t16.messageBus.call(t16.LOG_EVENT_FROM_LUA_DESCRIPTOR, t17)
end
function t3.logEphemeralStatEvent(t18: {[any]: any}, p15, n5: number) -- line: 269
	local t19 = {
		eventType = "EphemeralStat",
		config = p15,
		data = {
			statValue = n5
		}
	}

	t18.messageBus.call(t18.LOG_EVENT_FROM_LUA_DESCRIPTOR, t19)
end

t3.default = t3.new()

return t3
