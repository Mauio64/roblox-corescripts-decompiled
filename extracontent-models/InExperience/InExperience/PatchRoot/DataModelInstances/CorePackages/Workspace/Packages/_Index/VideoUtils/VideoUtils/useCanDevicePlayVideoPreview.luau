local TelemetryService = game:GetService("TelemetryService")
local VideoUtils = script:FindFirstAncestor("VideoUtils")
local VideoUtilsParent = VideoUtils.Parent
local React = require(VideoUtilsParent.React)
local LoggingProtocol = require(VideoUtilsParent.LoggingProtocol)
local reportWarning = require(VideoUtilsParent.DiscoveryAnalytics).Points.reportWarning
local SystemInfoProtocol = require(VideoUtilsParent.SystemInfoProtocol).SystemInfoProtocol
local VideoBlockingHelpers = require(VideoUtils.VideoBlockingHelpers)
local FFlagLuaAppShareEdpVideoBlockingConfig = require(VideoUtilsParent.SharedFlags).FFlagLuaAppShareEdpVideoBlockingConfig
local u10 = if not FFlagLuaAppShareEdpVideoBlockingConfig then {
	eventName = "EdpVideoPreviewBlockingStatus",
	description = "Telemetry about whether or not the video is blocked by manufacturer/device/max memory",
	backends = {
		"Points",
		"EventIngest"
	},
	lastUpdated = {
		26,
		1,
		19
	},
	throttlingPercentage = game:DefineFastInt("VideoBlockingTelemetryThrottleHundredthsPercent", 10000)
} else VideoBlockingHelpers.VideoBlockingTelemetryConfig
local u11 = nil

local function getSystemInfoLazy() -- line: 40
	-- upvalues: u11 (ref), SystemInfoProtocol (copy), reportWarning (copy), LoggingProtocol (copy)
	if u11 then
		return u11
	end

	local t1 = {
		manufacturer = nil,
		deviceName = nil,
		maxMemory = nil
	}
	local ok, result = pcall(function() -- line: 51
		-- upvalues: SystemInfoProtocol (copy)
		local v24 = SystemInfoProtocol.default:getSystemInfo({
			SystemInfoProtocol.InfoNames.MANUFACTURER,
			SystemInfoProtocol.InfoNames.DEVICE_NAME,
			SystemInfoProtocol.InfoNames.MAX_MEMORY
		})

		return {
			manufacturer = v24.manufacturer,
			deviceName = v24.deviceName,
			maxMemory = v24.maxMemory
		}
	end)

	if ok then
		t1 = result
	else
		reportWarning(LoggingProtocol.default, "EdpVideoPreviewBlocking", `Error retrieving device info for video preview blocking check: { result }`)
	end

	u11 = t1

	return t1
end
local function useCanDevicePlayVideoPreview(t2: {[any]: any}, s1: string, s2: string) -- line: 93
	-- upvalues: React (copy), getSystemInfoLazy (copy), FFlagLuaAppShareEdpVideoBlockingConfig (copy), VideoBlockingHelpers (copy), SystemInfoProtocol (copy), reportWarning (copy), LoggingProtocol (copy), TelemetryService (copy), u10 (ref)
	local v20 = React.useMemo(function() -- line: 99
		-- upvalues: getSystemInfoLazy (copy)
		return (getSystemInfoLazy())
	end, {})
	local v21 = React.useMemo(function() -- line: 103
		-- upvalues: t2 (copy), FFlagLuaAppShareEdpVideoBlockingConfig (copy), VideoBlockingHelpers (copy), v20 (copy)
		if not t2.enableManufacturerDeny or not t2.manufacturerDenyList then
			return false
		end

		if FFlagLuaAppShareEdpVideoBlockingConfig then
			return VideoBlockingHelpers.isInPipeDenyList(v20.manufacturer, t2.manufacturerDenyList)
		end

		if typeof(v20.manufacturer) == "string" then
			for match in t2.manufacturerDenyList:gmatch("([^|]+)") do
				if typeof(match) == "string" and string.lower(match) == string.lower(v20.manufacturer) then
					return true
				end
			end
		end

		return false
	end, {
		t2.enableManufacturerDeny,
		t2.manufacturerDenyList,
		v20.manufacturer
	})
	local v22 = React.useMemo(function() -- line: 123
		-- upvalues: t2 (copy), FFlagLuaAppShareEdpVideoBlockingConfig (copy), VideoBlockingHelpers (copy), v20 (copy)
		if not t2.enableDeviceDeny or not t2.deviceDenyList then
			return false
		end

		if FFlagLuaAppShareEdpVideoBlockingConfig then
			return VideoBlockingHelpers.isInPipeDenyList(v20.deviceName, t2.deviceDenyList)
		end

		if typeof(v20.deviceName) == "string" then
			for match in t2.deviceDenyList:gmatch("([^|]+)") do
				if typeof(match) == "string" and string.lower(match) == string.lower(v20.deviceName) then
					return true
				end
			end
		end

		return false
	end, {
		t2.enableDeviceDeny,
		t2.deviceDenyList,
		v20.deviceName
	})
	local v23 = React.useMemo(function() -- line: 143
		-- upvalues: t2 (copy), v20 (copy)
		if not t2.enableMaxMemoryDeny then
			return false
		end

		local v27 = t2.maxMemoryThresholdMb or -1

		if v27 > 0 and typeof(v20.maxMemory) == "string" then
			local num = tonumber(v20.maxMemory:match("(%d+)"))

			if num and num < v27 then
				return true
			end
		end

		return false
	end, {
		t2.enableMaxMemoryDeny,
		t2.maxMemoryThresholdMb,
		v20.maxMemory
	})

	return (React.useCallback(function() -- line: 160
		-- upvalues: t2 (copy), SystemInfoProtocol (copy), reportWarning (copy), LoggingProtocol (copy), TelemetryService (copy), u10 (ref), s2 (copy), s1 (copy), v21 (copy), v22 (copy), v23 (copy)
		local v29 = false
		local num = nil

		if t2.enableAvailableRamDeny and (t2.availableRamThresholdMb and t2.availableRamThresholdMb > 0) then
			local ok, result = pcall(function() -- line: 169
				-- upvalues: SystemInfoProtocol (copy), num (ref), t2 (copy)
				local v33 = SystemInfoProtocol.default:getSystemInfo({ SystemInfoProtocol.InfoNames.AVAIL_RAM })

				if typeof(v33.availRAM) == "string" then
					num = tonumber(v33.availRAM)

					if num and num < t2.availableRamThresholdMb then
						return true
					end
				end

				return false
			end)

			if ok then
				v29 = result
			else
				reportWarning(LoggingProtocol.default, "EdpVideoPreviewBlocking", `Error retrieving available RAM for video preview blocking check: { result }`)
			end
		end

		TelemetryService:LogEvent(u10, {
			standardizedFields = {
				"addOSInfo",
				"addSessionInfo"
			},
			customFields = {
				pageContext = s2,
				universeId = s1,
				isBlockedByManufacturer = if not t2.enableManufacturerDeny then nil else v21,
				isBlockedByDevice = if not t2.enableDeviceDeny then nil else v22,
				isBlockedByMaxMemory = if not t2.enableMaxMemoryDeny then nil else v23,
				isBlockedByAvailableRam = if not t2.enableAvailableRamDeny then nil else v29,
				availableRam = if not t2.enableAvailableRamDeny then nil else num
			}
		})

		return not (t2.enableManufacturerDeny and v21 or (t2.enableDeviceDeny and v22 or (t2.enableMaxMemoryDeny and v23 or t2.enableAvailableRamDeny and v29)))
	end, {
		t2.enableManufacturerDeny,
		t2.enableDeviceDeny,
		t2.enableMaxMemoryDeny,
		t2.enableAvailableRamDeny,
		t2.availableRamThresholdMb,
		v21,
		v22,
		v23,
		s1,
		s2
	}))
end

return useCanDevicePlayVideoPreview
