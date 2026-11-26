local TelemetryService = game:GetService("TelemetryService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/LoggingProtocol")
local reportWarning = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/DiscoveryAnalytics").Points.reportWarning
local systemInfoProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SystemInfoProtocol").SystemInfoProtocol

local VideoBlockingHelpers = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoBlockingHelpers")

local videoBlockingTelemetryConfig = VideoBlockingHelpers.VideoBlockingTelemetryConfig

local v5 = nil

local function getSystemInfoLazy()
	if v5 then
		return v5
	end

	local v6 = { manufacturer = nil, deviceName = nil, maxMemory = nil }

	local success, result = pcall(function()
		local systemInfo = systemInfoProtocol.default:getSystemInfo({
			systemInfoProtocol.InfoNames.MANUFACTURER,
			systemInfoProtocol.InfoNames.DEVICE_NAME,
			systemInfoProtocol.InfoNames.MAX_MEMORY
		})

		return {
			manufacturer = systemInfo.manufacturer,
			deviceName = systemInfo.deviceName,
			maxMemory = systemInfo.maxMemory
		}
	end)

	if success then
		v6 = result
	else
		reportWarning(
			LoggingProtocol.default,
			"EdpVideoPreviewBlocking",
			`Error retrieving device info for video preview blocking check: {result}`
		)
	end

	v5 = v6
	return v6
end

local function useCanDevicePlayVideoPreview(data, p2, p3)
	local v6 = React.useMemo(function()
		return getSystemInfoLazy()
	end, {})

	local v7 = React.useMemo(function()
		if data.enableManufacturerDeny and data.manufacturerDenyList then
			return VideoBlockingHelpers.isInPipeDenyList(v6.manufacturer, data.manufacturerDenyList)
		end

		return false
	end, { data.enableManufacturerDeny, data.manufacturerDenyList, v6.manufacturer })

	local v8 = React.useMemo(function()
		if data.enableDeviceDeny and data.deviceDenyList then
			return VideoBlockingHelpers.isInPipeDenyList(v6.deviceName, data.deviceDenyList)
		end

		return false
	end, { data.enableDeviceDeny, data.deviceDenyList, v6.deviceName })

	local v9 = React.useMemo(function(): boolean
		if not data.enableMaxMemoryDeny then
			return false
		end

		local maxMemoryThresholdMb = data.maxMemoryThresholdMb or -1

		if maxMemoryThresholdMb > 0 and typeof(v6.maxMemory) == "string" then
			local v10 = tonumber(v6.maxMemory:match("(%d+)"))

			if v10 and v10 < maxMemoryThresholdMb then
				return true
			end
		end

		return false
	end, { data.enableMaxMemoryDeny, data.maxMemoryThresholdMb, v6.maxMemory })

	return (React.useCallback(function(): boolean
		local v10 = false
		local availRAM = nil

		if
			data.enableAvailableRamDeny
			and data.availableRamThresholdMb
			and data.availableRamThresholdMb > 0
		then
			local success, result = pcall(function(): boolean
				local systemInfo = systemInfoProtocol.default:getSystemInfo({ systemInfoProtocol.InfoNames.AVAIL_RAM })

				if typeof(systemInfo.availRAM) == "string" then
					availRAM = tonumber(systemInfo.availRAM)

					if availRAM and availRAM < data.availableRamThresholdMb then
						return true
					end
				end

				return false
			end)

			if success then
				v10 = result
			else
				reportWarning(
					LoggingProtocol.default,
					"EdpVideoPreviewBlocking",
					`Error retrieving available RAM for video preview blocking check: {result}`
				)
			end
		end

		local v14 = {
			pageContext = p3,
			universeId = p2,
			isBlockedByManufacturer = 0,
			isBlockedByDevice = 0,
			isBlockedByMaxMemory = 0,
			isBlockedByAvailableRam = 0,
			availableRam = 0
		}

		local v15 = if data.enableManufacturerDeny then v7 else nil
		v14.isBlockedByManufacturer = v15

		local v16 = if data.enableDeviceDeny then v8 else nil
		v14.isBlockedByDevice = v16
		local v17 = if data.enableMaxMemoryDeny then v9 else nil
		v14.isBlockedByMaxMemory = v17
		local v18 = if data.enableAvailableRamDeny then v10 else nil
		v14.isBlockedByAvailableRam = v18
		local v19 = if data.enableAvailableRamDeny then availRAM else nil
		v14.availableRam = v19
		TelemetryService:LogEvent(videoBlockingTelemetryConfig, {
			standardizedFields = { "addOSInfo", "addSessionInfo" },
			customFields = v14
		})

		return not (data.enableManufacturerDeny and v7 or data.enableDeviceDeny and v8 or data.enableMaxMemoryDeny and v9 or data.enableAvailableRamDeny and v10)
	end, {
		data.enableManufacturerDeny,
		data.enableDeviceDeny,
		data.enableMaxMemoryDeny,
		data.enableAvailableRamDeny,
		data.availableRamThresholdMb,
		v7,
		v8,
		v9,
		p2,
		p3
	}))
end

return useCanDevicePlayVideoPreview
