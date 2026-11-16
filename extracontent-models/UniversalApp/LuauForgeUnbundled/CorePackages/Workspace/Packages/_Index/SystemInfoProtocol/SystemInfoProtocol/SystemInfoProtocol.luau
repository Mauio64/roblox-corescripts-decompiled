local messageBus = require("@game/CorePackages/Workspace/Packages/_Workspace/SystemInfoProtocol/MessageBus").MessageBus
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/SystemInfoProtocol/t")

require("@game/CorePackages/Workspace/Packages/_Index/SystemInfoProtocol/SystemInfoProtocol/SystemInfoProtocolTypes")

local v5 = {
	GET_SYSTEM_INFO_DESCRIPTOR = {
		fid = messageBus.getMessageId("SystemInfo", "getSystemInfo"),
		validateParams = t.table
	}
}

v5.InfoNames = {
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

v5.ALL_INFO_NAMES = {
	v5.InfoNames.MANUFACTURER,
	v5.InfoNames.DEVICE_NAME,
	v5.InfoNames.MAX_MEMORY,
	v5.InfoNames.MAX_RESOLUTION,
	v5.InfoNames.BASE_OS,
	v5.InfoNames.SYSTEM_VERSION,
	v5.InfoNames.APP_VERSION,
	v5.InfoNames.CPU_MAKE,
	v5.InfoNames.IS_64BIT,
	v5.InfoNames.CPU_LOGICAL_COUNT,
	v5.InfoNames.CPU_CORE_COUNT,
	v5.InfoNames.CPU_PHYS_COUNT,
	v5.InfoNames.CPU_SPEED,
	v5.InfoNames.GPU,
	v5.InfoNames.AVAIL_RAM,
	v5.InfoNames.NETWORK_TYPE
}

if game:GetEngineFeature("NewSystemInfoFeaturesEnabled") then
	table.insert(v5.ALL_INFO_NAMES, v5.InfoNames.BATTERY_LEVEL)
	table.insert(v5.ALL_INFO_NAMES, v5.InfoNames.THERMAL_STATUS)
end

v5.__index = v5

function v5.new(p2)
	return (setmetatable({
		messageBus = p2 or messageBus
	}, v5))
end

function v5:getSystemInfo(p3)
	return self.messageBus.call(self.GET_SYSTEM_INFO_DESCRIPTOR, p3)
end

v5.default = v5.new()

return v5
