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
		local v37

		if maxMemory == nil then
			v37 = nil
		else
			local num = tonumber(maxMemory)

			v37 = if num ~= nil then if not (num < 0) then math.floor(num) else 0 else nil
		end

		if v37 ~= nil then
			t10.memory_size = v37
		end
	end

	if attributes.availRAM ~= nil then
		local availRAM = attributes.availRAM
		local v40

		if availRAM == nil then
			v40 = nil
		else
			local num = tonumber(availRAM)

			v40 = if num ~= nil then if not (num < 0) then math.floor(num) else 0 else nil
		end

		if v40 ~= nil then
			t10.free_memory = v40
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
		local v43

		if cpuLogicalCount == nil then
			v43 = nil
		else
			local num = tonumber(cpuLogicalCount)

			v43 = if num ~= nil then if not (num < 0) then math.floor(num) else 0 else nil
		end

		if v43 ~= nil then
			t10.processor_count = v43
		end
	end

	if attributes.cpuCoreCount ~= nil then
		local cpuCoreCount = attributes.cpuCoreCount
		local v46

		if cpuCoreCount == nil then
			v46 = nil
		else
			local num = tonumber(cpuCoreCount)

			v46 = if num ~= nil then if not (num < 0) then math.floor(num) else 0 else nil
		end

		if v46 ~= nil then
			t10.cpu_core_count = v46
		end
	end

	if attributes.cpuMake ~= nil then
		t10.cpu_description = attributes.cpuMake
	end

	if attributes.cpuPhysCount ~= nil then
		local cpuPhysCount = attributes.cpuPhysCount
		local v49

		if cpuPhysCount == nil then
			v49 = nil
		else
			local num = tonumber(cpuPhysCount)

			v49 = if num ~= nil then if not (num < 0) then math.floor(num) else 0 else nil
		end

		if v49 ~= nil then
			t10.cpu_physical_count = v49
		end
	end

	if attributes.cpuSpeed ~= nil then
		local cpuSpeed = attributes.cpuSpeed
		local v52

		if cpuSpeed == nil then
			v52 = nil
		else
			local num = tonumber(cpuSpeed)

			v52 = if num ~= nil then if not (num < 0) then math.floor(num) else 0 else nil
		end

		if v52 ~= nil then
			t10.cpu_speed = v52
		end
	end

	return t10
end

function t1.parseErrorToContext(p8) -- line: 655
	-- upvalues: parseAppContext (copy), parseDeviceContext (copy)
	local t11 = {
		app = parseAppContext(p8)
	}
	local t12 = {}

	if p8.attributes.networkType ~= nil then
		t12.network_type = p8.attributes.networkType
	end

	t11.network = t12

	local t13 = {}
	local attributes = p8.attributes

	if attributes.baseOs ~= nil then
		t13.name = attributes.baseOs
	end

	if attributes.systemVersion ~= nil then
		t13.version = attributes.systemVersion
	end

	if attributes.systemVersion ~= nil then
		t13.version = attributes.systemVersion
	end

	t11.os = t13
	t11.device = parseDeviceContext(p8)

	return t11
end

return t1
