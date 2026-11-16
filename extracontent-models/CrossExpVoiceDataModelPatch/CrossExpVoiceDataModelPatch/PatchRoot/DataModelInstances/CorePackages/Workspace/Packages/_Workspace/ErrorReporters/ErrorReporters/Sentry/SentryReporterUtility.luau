require(script.Parent.ErrorReport)
local parent = script:FindFirstAncestor("ErrorReporters").Parent

local SentryReporterUtility = {}

local defineFastFlag = game:DefineFastFlag("SentryIncludeRolloutFlagsContext", false)

local defineFastFlag2 = game:DefineFastFlag("SentryIncludeIxpEnrolledExperimentsContext", false)

local function isJsonCompatible(result): boolean -- 1 equivalent call inferred from this helper
	local typeName = typeof(result)

	if result == nil or typeName == "string" or typeName == "boolean" then
		return true
	end

	return typeName == "number" and result == result and result ~= 1e999 and result ~= -1e999
end

function SentryReporterUtility.safeGet(p, p2: string)
	local success, result = pcall(function()
		return p[p2]
	end)

	if not success then
		return "unparsable"
	end

	if isJsonCompatible(result) then -- inferred equivalent call
		return result
	end

	return "json_incompatible"
end

local function toUnsignedInt(safeGet) -- 6 equivalent calls inferred from this helper
	if safeGet == nil then
		return nil
	end

	local v = tonumber(safeGet)

	if v == nil then
		return nil
	end

	if v < 0 then
		return 0
	end

	return (math.floor(v))
end

local function convertErrorStackToSentryFrame(data)
	local v = {
		lineno = tonumber(data.line) or 0
	}

	if data.funcName then
		v["function"] = data.funcName
	end

	if data.sourceCode then
		v.filename = data.sourceCode
		v.abs_path = data.sourceCode
	end

	if data.column then
		v.colno = tonumber(data.column)
	end

	if data.library then
		v.module = data.library
	end

	if data.address then
		v.instruction_addr = data.address
	end

	if data.guessed_frame == false then
		v.in_app = true
	end

	return v
end

function SentryReporterUtility.parseThreadsToSentry(items)
	if not items then
		return nil
	end

	local id = 1
	local values = {}

	for k, item in pairs(items) do
		local v = {
			id = id,
			name = item.name or k
		}

		if k == "main" or item.name == "main" then
			v.main = true
		end

		if item.fault == true then
			v.crashed = true
		end

		if item.stack and #item.stack > 0 then
			local v2 = {}

			for _, v3 in ipairs(item.stack) do
				table.insert(v2, convertErrorStackToSentryFrame(v3))
			end

			local frames = {}

			for i = #v2, 1, -1 do
				table.insert(frames, v2[i])
			end

			v.stacktrace = { frames = frames }
		end

		table.insert(values, v)
		id += 1
	end

	if #values == 0 then
		return nil
	end

	return { values = values }
end

local function parseAppContext(p)
	local appContext = {}
	local attributes = p.attributes

	local safeGet = SentryReporterUtility.safeGet(attributes, "appVersion")

	if safeGet ~= nil then
		appContext.app_version = safeGet
	end

	local safeGet2 = SentryReporterUtility.safeGet(attributes, "AppInstallationId")

	if safeGet2 ~= nil then
		appContext.device_app_hash = safeGet2
	end

	local safeGet3 = SentryReporterUtility.safeGet(attributes, "CoreScriptVersion")

	if safeGet3 ~= nil then
		appContext.core_script_version = safeGet3
	end

	local safeGet4 = SentryReporterUtility.safeGet(attributes, "RobloxChannel")

	if safeGet4 ~= nil then
		appContext.roblox_channel = safeGet4
	end

	local safeGet5 = SentryReporterUtility.safeGet(attributes, "AppRunningTime")

	if safeGet5 ~= nil then
		appContext.app_running_time = safeGet5
	end

	local safeGet6 = SentryReporterUtility.safeGet(attributes, "UserAgent")

	if safeGet6 ~= nil then
		appContext.user_agent = safeGet6
	end

	local safeGet7 = SentryReporterUtility.safeGet(attributes, "BaseUrl")

	if safeGet7 ~= nil then
		appContext.base_url = safeGet7
	end

	local safeGet8 = SentryReporterUtility.safeGet(attributes, "WindowsLaunchType")

	if safeGet8 ~= nil then
		appContext.windows_launch_type = safeGet8
	end

	local safeGet9 = SentryReporterUtility.safeGet(attributes, "CountryCode")

	if safeGet9 ~= nil then
		appContext.country_code = safeGet9
	end

	if defineFastFlag then
		local safeGet10 = SentryReporterUtility.safeGet(attributes, "RolloutFlagsInControl")

		if safeGet10 ~= nil then
			appContext.rollout_flags_in_control = safeGet10
		end

		local safeGet11 = SentryReporterUtility.safeGet(attributes, "RolloutFlagsInVariant")

		if safeGet11 ~= nil then
			appContext.rollout_flags_in_variant = safeGet11
		end
	end

	if defineFastFlag2 then
		local safeGet10 = SentryReporterUtility.safeGet(attributes, "IxpEnrolledExperiments")

		if safeGet10 ~= nil then
			appContext.ixp_enrolled_experiments = safeGet10
		end
	end

	return appContext
end

local function parseNetworkContext(p) -- 1 equivalent call inferred from this helper
	local networkContext = {}

	local safeGet = SentryReporterUtility.safeGet(p.attributes, "networkType")

	if safeGet ~= nil then
		networkContext.network_type = safeGet
	end

	return networkContext
end

local function parseOSContext(p)
	local osContext = {}
	local attributes = p.attributes

	local safeGet = SentryReporterUtility.safeGet(attributes, "baseOs")

	if safeGet ~= nil then
		osContext.name = safeGet
	end

	local safeGet2 = SentryReporterUtility.safeGet(attributes, "systemVersion")

	if safeGet2 ~= nil then
		osContext.version = safeGet2
	end

	return osContext
end

local function parseDeviceContext(p)
	local deviceContext = {}
	local attributes = p.attributes

	local safeGet = SentryReporterUtility.safeGet(attributes, "deviceName")

	if safeGet ~= nil then
		deviceContext.name = safeGet
	end

	local safeGet2 = SentryReporterUtility.safeGet(attributes, "batteryLevel")

	if safeGet2 ~= nil then
		local battery_level = tonumber(safeGet2)

		if battery_level ~= nil then
			deviceContext.battery_level = battery_level
		end
	end

	local safeGet3 = SentryReporterUtility.safeGet(attributes, "manufacturer")

	if safeGet3 ~= nil then
		deviceContext.manufacturer = safeGet3
	end

	local safeGet4 = SentryReporterUtility.safeGet(attributes, "maxMemory")

	if safeGet4 ~= nil then
		local memory_size = toUnsignedInt(safeGet4) -- inferred equivalent call

		if memory_size ~= nil then
			deviceContext.memory_size = memory_size
		end
	end

	local safeGet5 = SentryReporterUtility.safeGet(attributes, "availRAM")

	if safeGet5 ~= nil then
		local free_memory = toUnsignedInt(safeGet5) -- inferred equivalent call

		if free_memory ~= nil then
			deviceContext.free_memory = free_memory
		end
	end

	local safeGet6 = SentryReporterUtility.safeGet(attributes, "maxResolution")

	if safeGet6 ~= nil then
		deviceContext.screen_resolution = safeGet6
	end

	local safeGet7 = SentryReporterUtility.safeGet(attributes, "thermalStatus")

	if safeGet7 ~= nil then
		deviceContext.thermal_status = safeGet7
	end

	local safeGet8 = SentryReporterUtility.safeGet(attributes, "cpuLogicalCount")

	if safeGet8 ~= nil then
		local processor_count = toUnsignedInt(safeGet8) -- inferred equivalent call

		if processor_count ~= nil then
			deviceContext.processor_count = processor_count
		end
	end

	local safeGet9 = SentryReporterUtility.safeGet(attributes, "cpuCoreCount")

	if safeGet9 ~= nil then
		local cpu_core_count = toUnsignedInt(safeGet9) -- inferred equivalent call

		if cpu_core_count ~= nil then
			deviceContext.cpu_core_count = cpu_core_count
		end
	end

	local safeGet10 = SentryReporterUtility.safeGet(attributes, "cpuMake")

	if safeGet10 ~= nil then
		deviceContext.cpu_description = safeGet10
	end

	local safeGet11 = SentryReporterUtility.safeGet(attributes, "cpuPhysCount")

	if safeGet11 ~= nil then
		local cpu_physical_count = toUnsignedInt(safeGet11) -- inferred equivalent call

		if cpu_physical_count ~= nil then
			deviceContext.cpu_physical_count = cpu_physical_count
		end
	end

	local safeGet12 = SentryReporterUtility.safeGet(attributes, "cpuSpeed")

	if safeGet12 ~= nil then
		local cpu_speed = toUnsignedInt(safeGet12) -- inferred equivalent call

		if cpu_speed ~= nil then
			deviceContext.cpu_speed = cpu_speed
		end
	end

	return deviceContext
end

local function parseCustomMetadataContexts(p)
	local customMetadataContexts = {}
	local customMetadata = p.customMetadata

	if type(customMetadata) ~= "table" then
		return customMetadataContexts
	end

	for k, v in customMetadata do
		if not (type(v) == "table" and next(v) ~= nil) then
			continue
		end

		customMetadataContexts[k] = v
	end

	return customMetadataContexts
end

function SentryReporterUtility.parseErrorToContext(p)
	local errorToContext = {}

	errorToContext.app = parseAppContext(p)
	errorToContext.network = parseNetworkContext(p) -- inferred equivalent call
	errorToContext.os = parseOSContext(p)
	errorToContext.device = parseDeviceContext(p)

	for k, v in parseCustomMetadataContexts(p) do
		errorToContext[k] = v
	end

	return errorToContext
end

return SentryReporterUtility
