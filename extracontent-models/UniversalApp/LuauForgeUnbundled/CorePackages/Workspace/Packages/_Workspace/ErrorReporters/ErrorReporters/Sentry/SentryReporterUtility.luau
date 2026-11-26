require("@game/CorePackages/Workspace/Packages/_Workspace/ErrorReporters/ErrorReporters/Sentry/ErrorReport")

local v5 = {}

local defineFastFlag = game:DefineFastFlag("SentryIncludeRolloutFlagsContext", false)

local defineFastFlag2 = game:DefineFastFlag("SentryIncludeIxpEnrolledExperimentsContext", false)

local function isJsonCompatible(p2): boolean
	local typeName = typeof(p2)

	if p2 == nil or typeName == "string" or typeName == "boolean" then
		return true
	end

	if typeName ~= "number" then
		return false
	end

	return p2 == p2 and p2 ~= 1e999 and p2 ~= -1e999
end

function v5.safeGet(p2, p3)
	local success, result = pcall(function()
		return p2[p3]
	end)

	if not success then
		return "unparsable"
	end

	local typeName = typeof(result)
	local v6

	if result == nil or typeName == "string" or typeName == "boolean" then
		v6 = true
	else
		v6 = typeName == "number" and result == result and result ~= 1e999 and result ~= -1e999
	end

	if v6 then
		return result
	end

	return "json_incompatible"
end

local function toUnsignedInt(p2)
	if p2 == nil then
		return nil
	end

	local v6 = tonumber(p2)

	if v6 == nil then
		return nil
	end

	if v6 < 0 then
		return 0
	end

	return (math.floor(v6))
end

local function convertErrorStackToSentryFrame(data)
	local v6 = {
		lineno = tonumber(data.line) or 0
	}

	if data.funcName then
		v6["function"] = data.funcName
	end

	if data.sourceCode then
		v6.filename = data.sourceCode
		v6.abs_path = data.sourceCode
	end

	if data.column then
		v6.colno = tonumber(data.column)
	end

	if data.library then
		v6.module = data.library
	end

	if data.address then
		v6.instruction_addr = data.address
	end

	if data.guessed_frame == false then
		v6.in_app = true
	end

	return v6
end

function v5.parseThreadsToSentry(items)
	if not items then
		return nil
	end

	local v6 = 1
	local v7 = {}

	for k, item in pairs(items) do
		local v8 = {
			id = v6,
			name = item.name or k
		}

		if k == "main" or item.name == "main" then
			v8.main = true
		end

		if item.fault == true then
			v8.crashed = true
		end

		if item.stack and #item.stack > 0 then
			local v9 = {}

			for i, v10 in ipairs(item.stack) do
				table.insert(v9, convertErrorStackToSentryFrame(v10))
			end

			local v10 = {}

			for i = #v9, 1, -1 do
				table.insert(v10, v9[i])
			end

			v8.stacktrace = { frames = v10 }
		end

		table.insert(v7, v8)
		v6 += 1
	end

	if #v7 == 0 then
		return nil
	end

	return { values = v7 }
end

local function parseAppContext(p2)
	local appContext = {}
	local attributes = p2.attributes

	local safeGet = v5.safeGet(attributes, "appVersion")

	if safeGet ~= nil then
		appContext.app_version = safeGet
	end

	local safeGet2 = v5.safeGet(attributes, "AppInstallationId")

	if safeGet2 ~= nil then
		appContext.device_app_hash = safeGet2
	end

	local safeGet3 = v5.safeGet(attributes, "CoreScriptVersion")

	if safeGet3 ~= nil then
		appContext.core_script_version = safeGet3
	end

	local safeGet4 = v5.safeGet(attributes, "RobloxChannel")

	if safeGet4 ~= nil then
		appContext.roblox_channel = safeGet4
	end

	local safeGet5 = v5.safeGet(attributes, "AppRunningTime")

	if safeGet5 ~= nil then
		appContext.app_running_time = safeGet5
	end

	local safeGet6 = v5.safeGet(attributes, "UserAgent")

	if safeGet6 ~= nil then
		appContext.user_agent = safeGet6
	end

	local safeGet7 = v5.safeGet(attributes, "BaseUrl")

	if safeGet7 ~= nil then
		appContext.base_url = safeGet7
	end

	local safeGet8 = v5.safeGet(attributes, "WindowsLaunchType")

	if safeGet8 ~= nil then
		appContext.windows_launch_type = safeGet8
	end

	local safeGet9 = v5.safeGet(attributes, "CountryCode")

	if safeGet9 ~= nil then
		appContext.country_code = safeGet9
	end

	if defineFastFlag then
		local safeGet10 = v5.safeGet(attributes, "RolloutFlagsInControl")

		if safeGet10 ~= nil then
			appContext.rollout_flags_in_control = safeGet10
		end

		local safeGet11 = v5.safeGet(attributes, "RolloutFlagsInVariant")

		if safeGet11 ~= nil then
			appContext.rollout_flags_in_variant = safeGet11
		end
	end

	if defineFastFlag2 then
		local safeGet10 = v5.safeGet(attributes, "IxpEnrolledExperiments")

		if safeGet10 ~= nil then
			appContext.ixp_enrolled_experiments = safeGet10
		end
	end

	return appContext
end

local function parseNetworkContext(p2)
	local networkContext = {}

	local safeGet = v5.safeGet(p2.attributes, "networkType")

	if safeGet ~= nil then
		networkContext.network_type = safeGet
	end

	return networkContext
end

local function parseOSContext(p2)
	local osContext = {}
	local attributes = p2.attributes

	local safeGet = v5.safeGet(attributes, "baseOs")

	if safeGet ~= nil then
		osContext.name = safeGet
	end

	local safeGet2 = v5.safeGet(attributes, "systemVersion")

	if safeGet2 ~= nil then
		osContext.version = safeGet2
	end

	return osContext
end

local function parseDeviceContext(p2)
	local deviceContext = {}
	local attributes = p2.attributes

	local safeGet = v5.safeGet(attributes, "deviceName")

	if safeGet ~= nil then
		deviceContext.name = safeGet
	end

	local safeGet2 = v5.safeGet(attributes, "batteryLevel")

	if safeGet2 ~= nil then
		local v6 = tonumber(safeGet2)

		if v6 ~= nil then
			deviceContext.battery_level = v6
		end
	end

	local safeGet3 = v5.safeGet(attributes, "manufacturer")

	if safeGet3 ~= nil then
		deviceContext.manufacturer = safeGet3
	end

	local safeGet4 = v5.safeGet(attributes, "maxMemory")

	if safeGet4 ~= nil then
		local v6

		if safeGet4 ~= nil then
			local v7 = tonumber(safeGet4)

			if v7 ~= nil then
				v6 = v7 < 0 and 0 or math.floor(v7)
			end
		end

		if v6 ~= nil then
			deviceContext.memory_size = v6
		end
	end

	local safeGet5 = v5.safeGet(attributes, "availRAM")

	if safeGet5 ~= nil then
		local v6

		if safeGet5 ~= nil then
			local v7 = tonumber(safeGet5)

			if v7 ~= nil then
				v6 = v7 < 0 and 0 or math.floor(v7)
			end
		end

		if v6 ~= nil then
			deviceContext.free_memory = v6
		end
	end

	local safeGet6 = v5.safeGet(attributes, "maxResolution")

	if safeGet6 ~= nil then
		deviceContext.screen_resolution = safeGet6
	end

	local safeGet7 = v5.safeGet(attributes, "thermalStatus")

	if safeGet7 ~= nil then
		deviceContext.thermal_status = safeGet7
	end

	local safeGet8 = v5.safeGet(attributes, "cpuLogicalCount")

	if safeGet8 ~= nil then
		local v6

		if safeGet8 ~= nil then
			local v7 = tonumber(safeGet8)

			if v7 ~= nil then
				v6 = v7 < 0 and 0 or math.floor(v7)
			end
		end

		if v6 ~= nil then
			deviceContext.processor_count = v6
		end
	end

	local safeGet9 = v5.safeGet(attributes, "cpuCoreCount")

	if safeGet9 ~= nil then
		local v6

		if safeGet9 ~= nil then
			local v7 = tonumber(safeGet9)

			if v7 ~= nil then
				v6 = v7 < 0 and 0 or math.floor(v7)
			end
		end

		if v6 ~= nil then
			deviceContext.cpu_core_count = v6
		end
	end

	local safeGet10 = v5.safeGet(attributes, "cpuMake")

	if safeGet10 ~= nil then
		deviceContext.cpu_description = safeGet10
	end

	local safeGet11 = v5.safeGet(attributes, "cpuPhysCount")

	if safeGet11 ~= nil then
		local v6

		if safeGet11 ~= nil then
			local v7 = tonumber(safeGet11)

			if v7 ~= nil then
				v6 = v7 < 0 and 0 or math.floor(v7)
			end
		end

		if v6 ~= nil then
			deviceContext.cpu_physical_count = v6
		end
	end

	local safeGet12 = v5.safeGet(attributes, "cpuSpeed")

	if safeGet12 == nil then
		return deviceContext
	end

	local v6

	if safeGet12 ~= nil then
		local v7 = tonumber(safeGet12)

		if v7 ~= nil then
			v6 = v7 < 0 and 0 or math.floor(v7)
		end
	end

	if v6 ~= nil then
		deviceContext.cpu_speed = v6
	end

	return deviceContext
end

local function parseCustomMetadataContexts(p2)
	local customMetadataContexts = {}
	local customMetadata = p2.customMetadata

	if type(customMetadata) ~= "table" then
		return customMetadataContexts
	end

	for k, v6 in customMetadata do
		if not (type(v6) == "table" and next(v6) ~= nil) then
			continue
		end

		customMetadataContexts[k] = v6
	end

	return customMetadataContexts
end

function v5.parseErrorToContext(p2)
	local errorToContext = {}

	errorToContext.app = parseAppContext(p2)
	local v6 = {}

	local safeGet = v5.safeGet(p2.attributes, "networkType")

	if safeGet ~= nil then
		v6.network_type = safeGet
	end

	errorToContext.network = v6
	errorToContext.os = parseOSContext(p2)
	errorToContext.device = parseDeviceContext(p2)

	for k, v7 in parseCustomMetadataContexts(p2) do
		errorToContext[k] = v7
	end

	return errorToContext
end

return v5
