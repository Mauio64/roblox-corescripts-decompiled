local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local MessageBus = require(CorePackages.Workspace.Packages.MessageBus).MessageBus
local default = require(CorePackages.Workspace.Packages.LoggingProtocol).default
local t = require(CorePackages.Packages.t)
local Url = require(Modules.LuaApp.Http.Url)
local HttpService = game:GetService("HttpService")
local v9 = Url.APIS_URL .. "v1/attribution-contexts"

game:DefineFastInt("AttributionContextRecordedThrottleHundredthsPercent", 10000)

local t1 = {
	eventName = "AttributionContextRecorded",
	description = "Outcome of every POST attempt by AttributionContextEventReceiver",
	backends = { default.TelemetryBackends.EventIngest },
	throttlingPercentage = game:GetFastInt("AttributionContextRecordedThrottleHundredthsPercent"),
	lastUpdated = {
		26,
		6,
		11
	}
}

local function recordAttributionContext(p1, p2) -- line: 25
	-- upvalues: HttpService (copy), default (copy), t1 (copy), v9 (copy)
	local v15 = p2 or {}
	local v16 = v15.httpService or HttpService
	local v17 = v15.loggingProtocol or default
	local v18 = v15.nowMs or function() -- line: 29
		return DateTime.now().UnixTimestampMillis
	end

	local function emit(p3, p4, p5) -- line: 33
		-- upvalues: v17 (copy), t1 (copy)
		v17:logRobloxTelemetryEvent(t1, {}, {
			status = p3,
			statusCode = p4 or 0,
			latencyMs = p5 or 0
		})
	end

	local v20 = if type(p1) ~= "table" then nil else p1.body

	if type(v20) ~= "string" or v20 == "" then
		v17:logRobloxTelemetryEvent(t1, {}, {
			status = "INVALID_PARAMS",
			statusCode = 0,
			latencyMs = 0
		})

		return
	end

	local v21 = v18()

	v16:RequestInternal({
		Method = "POST",
		Timeout = 5000,
		Url = v9,
		Body = v20,
		Headers = {
			["Content-Type"] = "application/json"
		},
		CachePolicy = Enum.HttpCachePolicy.None
	}):Start(function(p6, p7) -- line: 66
		-- upvalues: v18 (copy), v21 (copy), emit (copy)
		local v31 = v18() - v21

		if not p6 or not p7 then
			emit("NETWORK_ERROR", 0, v31)

			return
		end

		if p7.StatusCode ~= 200 then
			emit("HTTP_ERROR", p7.StatusCode, v31)

			return
		end

		emit("SUCCESS", p7.StatusCode, v31)
	end)
end

local v12 = Roact.PureComponent:extend("AttributionContextEventReceiver")

function v12.init(p8) -- line: 82
	-- upvalues: MessageBus (copy), t (copy), recordAttributionContext (copy)
	local t2 = {
		mid = MessageBus.getMessageId("Linking", "recordAttributionContext"),
		validateParams = t.table
	}

	p8.subscriber = MessageBus.Subscriber.new()
	p8.subscriber:subscribe(t2, function(p9) -- line: 96
		-- upvalues: recordAttributionContext (copy)
		recordAttributionContext(p9)
	end, false)

	local v24 = MessageBus.getLast(t2)

	if v24 then
		recordAttributionContext(v24)
	end
end
function v12.render(_) -- line: 109
	return nil
end

v12._recordAttributionContext = recordAttributionContext

return v12
