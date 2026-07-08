local CorePackages = game:GetService("CorePackages")
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local Cryo = require(CorePackages.Packages.Cryo)
local NextUpState = require(script.Parent.NextUpState)
local FFlagEnableNextUpImageLatencyTelemetry = require(script.Parent.Flags.FFlagEnableNextUpImageLatencyTelemetry)
local default = LoggingProtocol.default
local v7 = if not FFlagEnableNextUpImageLatencyTelemetry then nil else {
	LeaveGame = "LeaveGame",
	CloseExitModalClick = "CloseExitModalClick",
	CloseExitModalEscape = "CloseExitModalEscape",
	JoinGame = "JoinGame"
}
local t1 = {
	eventName = "InGameNextUpExitMenuSortRequestLatency",
	description = "Request latency for In-Game Exit Page network requests",
	backends = { LoggingProtocol.TelemetryBackends.Stats },
	lastUpdated = {
		25,
		7,
		16
	}
}
local t2 = {
	eventName = "InGameNextUpExitMenuSortView",
	description = "Next-up sort views from the In-Game Exit Modal",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	lastUpdated = {
		25,
		7,
		16
	}
}

local function logNextUpSortView(b1: boolean) -- line: 48
	-- upvalues: default (copy), t2 (copy)
	default:logRobloxTelemetryCounter(t2, 1, {
		tilesLoaded = tostring(b1)
	})
end

local v11 = if not FFlagEnableNextUpImageLatencyTelemetry then nil else {
	eventName = "InGameNextUpExitMenuSortView",
	description = "Next-up sort views from the In-Game Exit Modal",
	backends = { LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = game:DefineFastInt("InGameNextUpSortViewEventThrottlingPercentage", 0),
	lastUpdated = {
		25,
		7,
		22
	}
}
local v12 = if not FFlagEnableNextUpImageLatencyTelemetry then nil else function(n1: number) -- line: 67
	return n1 * 1000
end

return {
	logRequestLatency = function(s1: string, n2: number) -- line: 33
		-- upvalues: default (copy), t1 (copy)
		default:logRobloxTelemetryStat(t1, n2, {
			endpointName = s1
		})
	end,
	logNextUpSortView = if not FFlagEnableNextUpImageLatencyTelemetry then logNextUpSortView else nil,
	NextUpSortViewActionType = if not FFlagEnableNextUpImageLatencyTelemetry then nil else v7,
	logNextUpExitModalAction = if not FFlagEnableNextUpImageLatencyTelemetry then nil else if not FFlagEnableNextUpImageLatencyTelemetry then nil else function(s2: string) -- line: 73
		-- upvalues: NextUpState (copy), Cryo (copy), v12 (copy), default (copy), v11 (copy)
		local v18 = NextUpState.getNextUpComponentSortLatency()
		local v19 = Cryo.List.map(NextUpState.getNextUpTileImageTextureLatencies(), v12)

		default:logRobloxTelemetryEvent(v11, {}, {
			action = s2,
			sortLatency = if not v18 then nil else v12(v18),
			tileLatencies = if not (#v19 > 0) then nil else table.concat(v19, ",")
		})
	end
}
