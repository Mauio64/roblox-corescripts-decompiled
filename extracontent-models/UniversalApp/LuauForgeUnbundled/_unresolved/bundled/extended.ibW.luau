local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local messageBus = require("@luauforge/bundled/fBY").MessageBus
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default
local t = require(CorePackages.Packages.t)
local module = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

local HttpService = game:GetService("HttpService")

local v5 = module.APIS_URL .. "v1/attribution-contexts"

game:DefineFastInt("AttributionContextRecordedThrottleHundredthsPercent", 10000)
local v6 = {
	eventName = "AttributionContextRecorded",
	backends = { default.TelemetryBackends.EventIngest },
	throttlingPercentage = game:GetFastInt("AttributionContextRecordedThrottleHundredthsPercent"),
	lastUpdated = { 26, 6, 11 },
	description = "Outcome of every POST attempt by AttributionContextEventReceiver"
}

local function recordAttributionContext(p2, options)
	local v7 = options or {}
	local httpService = v7.httpService or HttpService
	local loggingProtocol = v7.loggingProtocol or default
	local nowMs = v7.nowMs or function()
		return DateTime.now().UnixTimestampMillis
	end

	local function emit(p3, value, value2)
		loggingProtocol:logRobloxTelemetryEvent(v6, {}, {
			status = p3,
			statusCode = value or 0,
			latencyMs = value2 or 0
		})
	end

	local body = if type(p2) == "table" then p2.body else nil

	if type(body) ~= "string" or body == "" then
		loggingProtocol:logRobloxTelemetryEvent(v6, {}, {
			status = "INVALID_PARAMS",
			statusCode = 0,
			latencyMs = 0
		})

		return
	end

	local v8 = nowMs()
	httpService:RequestInternal({
		Url = v5,
		Method = "POST",
		Body = body,
		Headers = { ["Content-Type"] = "application/json" },
		Timeout = 5000,
		CachePolicy = Enum.HttpCachePolicy.None
	}):Start(function(p3, p4)
		local v9 = nowMs() - v8

		if not (p3 and p4) then
			emit("NETWORK_ERROR", 0, v9)
		elseif p4.StatusCode == 200 then
			emit("SUCCESS", p4.StatusCode, v9)
		else
			emit("HTTP_ERROR", p4.StatusCode, v9)
		end
	end)
end

local extended = Roact.PureComponent:extend("AttributionContextEventReceiver")

function extended:init()
	local v7 = {
		mid = messageBus.getMessageId("Linking", "recordAttributionContext"),
		validateParams = t.table
	}

	self.subscriber = messageBus.Subscriber.new()
	self.subscriber:subscribe(v7, function(p3)
		recordAttributionContext(p3)
	end, false)

	local last = messageBus.getLast(v7)

	if last then
		recordAttributionContext(last)
	end
end

function extended.render(p2): nil
	return nil
end

extended._recordAttributionContext = recordAttributionContext

return extended
