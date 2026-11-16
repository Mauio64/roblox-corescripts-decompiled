local TelemetryService = game:GetService("TelemetryService")

local VideoUtils = script:FindFirstAncestor("VideoUtils")
local parent = VideoUtils.Parent

local React = require(parent.React)
local LoggingProtocol = require(parent.LoggingProtocol)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local reportWarning = DiscoveryAnalytics.Points.reportWarning
local SystemInfoProtocol = require(parent.SystemInfoProtocol)
local systemInfoProtocol = SystemInfoProtocol.SystemInfoProtocol

local VideoBlockingHelpers = require(VideoUtils.VideoBlockingHelpers)

local VideoBlockingTelemetryConfig = VideoBlockingHelpers.VideoBlockingTelemetryConfig

local v = nil

local function getSystemInfoLazy()
	if v then
		return v
	end

	local selected = { manufacturer = nil, deviceName = nil, maxMemory = nil }

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
		selected = result
	else
		reportWarning(
			LoggingProtocol.default,
			"EdpVideoPreviewBlocking",
			`Error retrieving device info for video preview blocking check: {result}`
		)
	end

	v = selected
	return selected
end

local function useCanDevicePlayVideoPreview(data, universeId: string, pageContext: string)
	local v2 = React.useMemo(function()
		return getSystemInfoLazy()
	end, {})

	local v3 = React.useMemo(function()
		if data.enableManufacturerDeny and data.manufacturerDenyList then
			return VideoBlockingHelpers.isInPipeDenyList(v2.manufacturer, data.manufacturerDenyList)
		end

		return false
	end, { data.enableManufacturerDeny, data.manufacturerDenyList, v2.manufacturer })

	local v4 = React.useMemo(function()
		if data.enableDeviceDeny and data.deviceDenyList then
			return VideoBlockingHelpers.isInPipeDenyList(v2.deviceName, data.deviceDenyList)
		end

		return false
	end, { data.enableDeviceDeny, data.deviceDenyList, v2.deviceName })

	local v5 = React.useMemo(function(): boolean
		if not data.enableMaxMemoryDeny then
			return false
		end

		local maxMemoryThresholdMb = data.maxMemoryThresholdMb or -1

		if maxMemoryThresholdMb > 0 and typeof(v2.maxMemory) == "string" then
			local v5 = tonumber(v2.maxMemory:match("(%d+)"))

			if v5 and v5 < maxMemoryThresholdMb then
				return true
			end
		end

		return false
	end, { data.enableMaxMemoryDeny, data.maxMemoryThresholdMb, v2.maxMemory })

	return (React.useCallback(function(): boolean
		local v6 = false
		local availRAM = nil

		if data.enableAvailableRamDeny and data.availableRamThresholdMb and data.availableRamThresholdMb > 0 then
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
				v6 = result
			else
				reportWarning(
					LoggingProtocol.default,
					"EdpVideoPreviewBlocking",
					`Error retrieving available RAM for video preview blocking check: {result}`
				)
			end
		end

		local customFields = {
			pageContext = pageContext,
			universeId = universeId,
			isBlockedByManufacturer = 0,
			isBlockedByDevice = 0,
			isBlockedByMaxMemory = 0,
			isBlockedByAvailableRam = 0,
			availableRam = 0
		}
		local isBlockedByManufacturer

		if data.enableManufacturerDeny then
			isBlockedByManufacturer = v3
		end

		customFields.isBlockedByManufacturer = isBlockedByManufacturer
		local isBlockedByDevice

		if data.enableDeviceDeny then
			isBlockedByDevice = v4
		end

		customFields.isBlockedByDevice = isBlockedByDevice
		local isBlockedByMaxMemory

		if data.enableMaxMemoryDeny then
			isBlockedByMaxMemory = v5
		end

		customFields.isBlockedByMaxMemory = isBlockedByMaxMemory
		local isBlockedByAvailableRam

		if data.enableAvailableRamDeny then
			isBlockedByAvailableRam = v6
		end

		customFields.isBlockedByAvailableRam = isBlockedByAvailableRam
		local availableRam

		if data.enableAvailableRamDeny then
			availableRam = availRAM
		end

		customFields.availableRam = availableRam
		TelemetryService:LogEvent(VideoBlockingTelemetryConfig, {
			standardizedFields = { "addOSInfo", "addSessionInfo" },
			customFields = customFields
		})

		return not (data.enableManufacturerDeny and v3 or data.enableDeviceDeny and v4 or data.enableMaxMemoryDeny and v5 or data.enableAvailableRamDeny and v6)
	end, {
		data.enableManufacturerDeny,
		data.enableDeviceDeny,
		data.enableMaxMemoryDeny,
		data.enableAvailableRamDeny,
		data.availableRamThresholdMb,
		v3,
		v4,
		v5,
		universeId,
		pageContext
	}))
end

return useCanDevicePlayVideoPreview
