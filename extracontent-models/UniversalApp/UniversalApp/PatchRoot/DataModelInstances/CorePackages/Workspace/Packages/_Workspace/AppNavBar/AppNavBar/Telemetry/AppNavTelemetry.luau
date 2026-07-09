local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local TelemetryService = require(ParentParentParent.MockableProxyServices).TelemetryService

require(ParentParent.Enum.Placement)

local DeviceTier = require(ParentParentParent.Devices).DeviceTier
local v5 = game:DefineFastFlag("AppNavDeviceTier", false)
local FFlagAppNavTelemetryLogger = require(ParentParentParent.SharedFlags).FFlagAppNavTelemetryLogger
local u7 = nil

if FFlagAppNavTelemetryLogger then
	u7 = require(ParentParentParent.Loggers).Logger:new("AppNavTelemetry")
end

local t1 = {
	"addOSInfo",
	"addSessionId",
	"addSessionInfo"
}
local v9 = if not v5 then nil else DeviceTier.GetDeviceMemoryTier()
local t2 = {
	eventName = "AppNav_SwitchTab",
	throttlingPercentage = 10000,
	description = "App Nav switch tab",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		2026,
		3,
		12
	}
}
local t3 = {
	eventName = "AppNav_SwitchTab",
	throttlingPercentage = 10000,
	description = "App Nav switch tab",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE",
	backends = { "EventIngest" },
	lastUpdated = {
		2026,
		3,
		12
	}
}
local t4 = {
	eventName = "AppNav_IsVisibleChanged",
	throttlingPercentage = 10000,
	description = "App Nav isVisible prop changed",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE",
	backends = { "RobloxTelemetryStat" },
	lastUpdated = {
		26,
		3,
		17
	}
}
local t5 = {
	eventName = "AppNav_IsVisibleChanged",
	throttlingPercentage = 10000,
	description = "App Nav isVisible prop changed",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE",
	backends = { "EventIngest" },
	lastUpdated = {
		26,
		3,
		17
	}
}
local t6 = {
	eventName = "AppNav_PlacementChanged",
	throttlingPercentage = 10000,
	description = "App Nav placement prop changed",
	links = "https://roblox.atlassian.net/wiki/x/1ACaAQE",
	backends = { "RobloxTelemetryCounter" },
	lastUpdated = {
		26,
		3,
		17
	}
}
local t7 = nil

local function reportSwitchTab(s1: string, s2: string, n1: number) -- line: 88
	-- upvalues: TelemetryService (copy), t2 (copy), v5 (copy), v9 (copy), t3 (copy), t1 (copy), FFlagAppNavTelemetryLogger (copy), u7 (ref)
	TelemetryService:LogStat(t2, {
		customFields = {
			previous_page = s1,
			current_page = s2,
			device_tier = if not v5 then nil else v9
		}
	}, n1)
	TelemetryService:LogEvent(t3, {
		customFields = {
			previous_page = s1,
			current_page = s2,
			duration = n1
		},
		standardizedFields = t1
	})

	if FFlagAppNavTelemetryLogger then
		u7:info("AppNav switch_tab previous={} current={} duration_ms={} device_tier={}", tostring(s1), tostring(s2), string.format("%.2f", n1), (tostring(v9)))
	end
end

local t8 = nil

local function reportVisibility(b1: boolean, n2: number) -- line: 141
	-- upvalues: TelemetryService (copy), t4 (copy), v5 (copy), v9 (copy), t5 (copy), t1 (copy), FFlagAppNavTelemetryLogger (copy), u7 (ref)
	TelemetryService:LogStat(t4, {
		customFields = {
			is_visible = b1,
			device_tier = if not v5 then nil else v9
		}
	}, n2)
	TelemetryService:LogEvent(t5, {
		customFields = {
			is_visible = b1,
			duration = n2
		},
		standardizedFields = t1
	})

	if FFlagAppNavTelemetryLogger then
		u7:info("AppNav is_visible_changed is_visible={} duration_ms={} device_tier={}", tostring(b1), string.format("%.2f", n2), (tostring(v9)))
	end
end

local u19 = nil

return {
	logSwitchTabStart = function(s3: string, s4: string) -- line: 80
		-- upvalues: t7 (ref)
		t7 = {
			previousPage = s3,
			nextPage = s4,
			startTime = os.clock()
		}
	end,
	logSwitchTabEnd = function(s5: string) -- line: 115
		-- upvalues: t7 (ref), reportSwitchTab (copy)
		if not t7 then
			return
		end

		if s5 ~= t7.nextPage then
			t7 = nil

			return
		end

		local previousPage = t7.previousPage
		local v27 = (os.clock() - t7.startTime) * 1000

		t7 = nil
		reportSwitchTab(previousPage, s5, v27)
	end,
	logVisibilityStart = function(b2: boolean) -- line: 134
		-- upvalues: t8 (ref)
		t8 = {
			nextValue = b2,
			startTime = os.clock()
		}
	end,
	logVisibilityEnd = function(b3: boolean) -- line: 165
		-- upvalues: t8 (ref), reportVisibility (copy)
		if not t8 then
			return
		end

		if b3 ~= t8.nextValue then
			t8 = nil

			return
		end

		local v32 = (os.clock() - t8.startTime) * 1000

		t8 = nil
		reportVisibility(b3, v32)
	end,
	logPlacement = function(p1) -- line: 183
		-- upvalues: u19 (ref), TelemetryService (copy), t6 (copy), FFlagAppNavTelemetryLogger (copy), u7 (ref)
		if p1 == u19 then
			return
		end

		TelemetryService:LogCounter(t6, {
			customFields = {
				previous_placement = u19,
				current_placement = p1
			}
		})

		if FFlagAppNavTelemetryLogger then
			u7:info("AppNav placement_changed previous={} current={}", tostring(u19), (tostring(p1)))
		end

		u19 = p1
	end,
	reset = function() -- line: 201
		-- upvalues: t7 (ref), t8 (ref), u19 (ref)
		t7 = nil
		t8 = nil
		u19 = nil
	end
}
