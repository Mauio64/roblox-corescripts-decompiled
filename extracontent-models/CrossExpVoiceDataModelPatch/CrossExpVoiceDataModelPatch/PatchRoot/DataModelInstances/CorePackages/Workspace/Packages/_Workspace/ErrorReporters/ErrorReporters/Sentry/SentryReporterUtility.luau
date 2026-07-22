require(script.Parent.ErrorReport)

local _ = script:FindFirstAncestor("ErrorReporters").Parent
local t1 = {}

local function toUnsignedInt(p1) -- line: 124
	if p1 == nil then
		return nil
	end

	local num = tonumber(p1)

	if num == nil then
		return nil
	end

	if num < 0 then
		return 0
	end

	return (math.floor(num))
end
local function convertErrorStackToSentryFrame(p2) -- line: 184
	local t2 = {
		lineno = tonumber(p2.line) or 0
	}

	if p2.funcName then
		t2["function"] = p2.funcName
	end

	if p2.sourceCode then
		t2.filename = p2.sourceCode
		t2.abs_path = p2.sourceCode
	end

	if p2.column then
		t2.colno = tonumber(p2.column)
	end

	if p2.library then
		t2.module = p2.library
	end

	if p2.address then
		t2.instruction_addr = p2.address
	end

	if p2.guessed_frame == false then
		t2.in_app = true
	end

	return t2
end

function t1.parseThreadsToSentry(p3) -- line: 286
	-- upvalues: convertErrorStackToSentryFrame (copy)
	if not p3 then
		return nil
	end

	local t3 = {}
	local n1 = 1

	for k, v in pairs(p3) do
		local t4 = {
			id = n1,
			name = v.name or k
		}

		if k == "main" or v.name == "main" then
			t4.main = true
		end

		if v.fault == true then
			t4.crashed = true
		end

		if v.stack and #v.stack > 0 then
			local t5 = {}

			for _, v2 in ipairs(v.stack) do
				table.insert(t5, (convertErrorStackToSentryFrame(v2)))
			end

			local t6 = {}

			for i = #t5, 1, -1 do
				table.insert(t6, t5[i])
			end

			t4.stacktrace = {
				frames = t6
			}
		end

		table.insert(t3, t4)
		n1 += 1
	end

	if #t3 == 0 then
		return nil
	end

	return {
		values = t3
	}
end

local function parseAppContext(p4) -- line: 371
	local t7 = {}
	local attributes = p4.attributes

	if attributes.appVersion ~= nil then
		t7.app_version = attributes.appVersion
	end

	if attributes.AppInstallationId ~= nil then
		t7.device_app_hash = attributes.AppInstallationId
	end

	if attributes.CoreScriptVersion ~= nil then
		t7.core_script_version = attributes.CoreScriptVersion
	end

	if attributes.RobloxChannel ~= nil then
		t7.roblox_channel = attributes.RobloxChannel
	end

	if attributes.AppRunningTime ~= nil then
		t7.app_running_time = attributes.AppRunningTime
	end

	if attributes.UserAgent ~= nil then
		t7.user_agent = attributes.UserAgent
	end

	if attributes.BaseUrl ~= nil then
		t7.base_url = attributes.BaseUrl
	end

	if attributes.WindowsLaunchType ~= nil then
		t7.windows_launch_type = attributes.WindowsLaunchType
	end

	if attributes.CountryCode ~= nil then
		t7.country_code = attributes.CountryCode
	end

	return t7
end
local function parseNetworkContext(p5) -- line: 436
	local t8 = {}

	if p5.attributes.networkType ~= nil then
		t8.network_type = p5.attributes.networkType
	end

	return t8
end
local function parseOSContext(p6) -- line: 470
	local t9 = {}
	local attributes = p6.attributes

	if attributes.baseOs ~= nil then
		t9.name = attributes.baseOs
	end

	if attributes.systemVersion ~= nil then
		t9.version = attributes.systemVersion
	end

	if attributes.systemVersion ~= nil then
		t9.version = attributes.systemVersion
	end

	return t9
end
local function parseDeviceContext(p7) -- line: 541
	local t10 = {}
	local attributes = p7.attributes

	if attributes.deviceName ~= nil then
		t10.name = attributes.deviceName
	end

	if attributes.batteryLevel ~= nil then
		local num = tonumber(attributes.batteryLevel)

		if num ~= nil then
			t10.battery_level = num
		end
	end

	if attributes.manufacturer ~= nil then
		t10.manufacturer = attributes.manufacturer
	end

	if attributes.maxMemory ~= nil then
		local maxMemory = attributes.maxMemory
		local v38

		if maxMemory == nil then
			v38 = nil
		else
			local num = tonumber(maxMemory)

			v38 = if num ~= nil then if not (num < 0) then math.floor(num) else 0 else nil
		end

		if v38 ~= nil then
			t10.memory_size = v38
		end
	end

	if attributes.availRAM ~= nil then
		local availRAM = attributes.availRAM
		local v41

		if availRAM == nil then
			v41 = nil
		else
			local num = tonumber(availRAM)

			v41 = if num ~= nil then if not (num < 0) then math.floor(num) else 0 else nil
		end

		if v41 ~= nil then
			t10.free_memory = v41
		end
	end

	if attributes.maxResolution ~= nil then
		t10.screen_resolution = attributes.maxResolution
	end

	if attributes.thermalStatus ~= nil then
		t10.thermal_status = attributes.thermalStatus
	end

	if attributes.cpuLogicalCount ~= nil then
		local cpuLogicalCount = attributes.cpuLogicalCount
		local v44

		if cpuLogicalCount == nil then
			v44 = nil
		else
			local num = tonumber(cpuLogicalCount)

			v44 = if num ~= nil then if not (num < 0) then math.floor(num) else 0 else nil
		end

		if v44 ~= nil then
			t10.processor_count = v44
		end
	end

	if attributes.cpuCoreCount ~= nil then
		local cpuCoreCount = attributes.cpuCoreCount
		local v47

		if cpuCoreCount == nil then
			v47 = nil
		else
			local num = tonumber(cpuCoreCount)

			v47 = if num ~= nil then if not (num < 0) then math.floor(num) else 0 else nil
		end

		if v47 ~= nil then
			t10.cpu_core_count = v47
		end
	end

	if attributes.cpuMake ~= nil then
		t10.cpu_description = attributes.cpuMake
	end

	if attributes.cpuPhysCount ~= nil then
		local cpuPhysCount = attributes.cpuPhysCount
		local v50

		if cpuPhysCount == nil then
			v50 = nil
		else
			local num = tonumber(cpuPhysCount)

			v50 = if num ~= nil then if not (num < 0) then math.floor(num) else 0 else nil
		end

		if v50 ~= nil then
			t10.cpu_physical_count = v50
		end
	end

	if attributes.cpuSpeed ~= nil then
		local cpuSpeed = attributes.cpuSpeed
		local v53

		if cpuSpeed == nil then
			v53 = nil
		else
			local num = tonumber(cpuSpeed)

			v53 = if num ~= nil then if not (num < 0) then math.floor(num) else 0 else nil
		end

		if v53 ~= nil then
			t10.cpu_speed = v53
		end
	end

	return t10
end
local function parseCustomMetadataContexts(p8) -- line: 628
	local t11 = {}
	local customMetadata = p8.customMetadata

	if type(customMetadata) ~= "table" then
		return t11
	end

	for v58, v59 in customMetadata do
		if type(v59) == "table" and next(v59) ~= nil then
			t11[v58] = v59
		end
	end

	return t11
end

function t1.parseErrorToContext(p9) -- line: 692
	-- upvalues: parseAppContext (copy), parseDeviceContext (copy), parseCustomMetadataContexts (copy)
	local t12 = {
		app = parseAppContext(p9)
	}
	local t13 = {}

	if p9.attributes.networkType ~= nil then
		t13.network_type = p9.attributes.networkType
	end

	t12.network = t13

	local t14 = {}
	local attributes = p9.attributes

	if attributes.baseOs ~= nil then
		t14.name = attributes.baseOs
	end

	if attributes.systemVersion ~= nil then
		t14.version = attributes.systemVersion
	end

	if attributes.systemVersion ~= nil then
		t14.version = attributes.systemVersion
	end

	t12.os = t14
	t12.device = parseDeviceContext(p9)

	for v65, v66 in parseCustomMetadataContexts(p9) do
		t12[v65] = v66
	end

	return t12
end

return t1
