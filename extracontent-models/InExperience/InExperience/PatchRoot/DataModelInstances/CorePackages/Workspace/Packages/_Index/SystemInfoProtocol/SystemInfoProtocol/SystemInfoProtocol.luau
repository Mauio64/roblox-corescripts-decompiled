local ParentParent = script.Parent.Parent
local MessageBus = require(ParentParent.MessageBus).MessageBus
local t = require(ParentParent.t)

require(script.Parent.SystemInfoProtocolTypes)

local t1 = {
	GET_SYSTEM_INFO_DESCRIPTOR = {
		fid = MessageBus.getMessageId("SystemInfo", "getSystemInfo"),
		validateParams = t.table
	},
	InfoNames = {
		MANUFACTURER = "manufacturer",
		DEVICE_NAME = "deviceName",
		MAX_MEMORY = "maxMemory",
		MAX_RESOLUTION = "maxResolution",
		BASE_OS = "baseOs",
		SYSTEM_VERSION = "systemVersion",
		APP_VERSION = "appVersion",
		CPU_MAKE = "cpuMake",
		IS_64BIT = "is64bit",
		CPU_LOGICAL_COUNT = "cpuLogicalCount",
		CPU_CORE_COUNT = "cpuCoreCount",
		CPU_PHYS_COUNT = "cpuPhysCount",
		CPU_SPEED = "cpuSpeed",
		GPU = "GPU",
		AVAIL_RAM = "availRAM",
		NETWORK_TYPE = "networkType",
		BATTERY_LEVEL = "batteryLevel",
		THERMAL_STATUS = "thermalStatus"
	}
}

t1.ALL_INFO_NAMES = {
	t1.InfoNames.MANUFACTURER,
	t1.InfoNames.DEVICE_NAME,
	t1.InfoNames.MAX_MEMORY,
	t1.InfoNames.MAX_RESOLUTION,
	t1.InfoNames.BASE_OS,
	t1.InfoNames.SYSTEM_VERSION,
	t1.InfoNames.APP_VERSION,
	t1.InfoNames.CPU_MAKE,
	t1.InfoNames.IS_64BIT,
	t1.InfoNames.CPU_LOGICAL_COUNT,
	t1.InfoNames.CPU_CORE_COUNT,
	t1.InfoNames.CPU_PHYS_COUNT,
	t1.InfoNames.CPU_SPEED,
	t1.InfoNames.GPU,
	t1.InfoNames.AVAIL_RAM,
	t1.InfoNames.NETWORK_TYPE
}

if game:GetEngineFeature("NewSystemInfoFeaturesEnabled") then
	table.insert(t1.ALL_INFO_NAMES, t1.InfoNames.BATTERY_LEVEL)
	table.insert(t1.ALL_INFO_NAMES, t1.InfoNames.THERMAL_STATUS)
end

t1.__index = t1

function t1.new(p1) -- line: 76
	-- upvalues: MessageBus (copy), t1 (copy)
	return (setmetatable({
		messageBus = p1 or MessageBus
	}, t1))
end
function t1.getSystemInfo(p2, p3) -- line: 97
	return p2.messageBus.call(p2.GET_SYSTEM_INFO_DESCRIPTOR, p3)
end

t1.default = t1.new()

return t1
