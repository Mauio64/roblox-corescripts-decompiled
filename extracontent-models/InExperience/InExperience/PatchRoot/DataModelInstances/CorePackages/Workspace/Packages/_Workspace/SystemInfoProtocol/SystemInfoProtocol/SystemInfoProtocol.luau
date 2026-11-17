local parent = script.Parent.Parent
local MessageBus = require(parent.MessageBus)
local messageBus = MessageBus.MessageBus
local t = require(parent.t)

require(script.Parent.SystemInfoProtocolTypes)

local SystemInfoProtocol = {
	GET_SYSTEM_INFO_DESCRIPTOR = {
		fid = messageBus.getMessageId("SystemInfo", "getSystemInfo"),
		validateParams = t.table
	}
}

SystemInfoProtocol.InfoNames = {
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

SystemInfoProtocol.ALL_INFO_NAMES = {
	SystemInfoProtocol.InfoNames.MANUFACTURER,
	SystemInfoProtocol.InfoNames.DEVICE_NAME,
	SystemInfoProtocol.InfoNames.MAX_MEMORY,
	SystemInfoProtocol.InfoNames.MAX_RESOLUTION,
	SystemInfoProtocol.InfoNames.BASE_OS,
	SystemInfoProtocol.InfoNames.SYSTEM_VERSION,
	SystemInfoProtocol.InfoNames.APP_VERSION,
	SystemInfoProtocol.InfoNames.CPU_MAKE,
	SystemInfoProtocol.InfoNames.IS_64BIT,
	SystemInfoProtocol.InfoNames.CPU_LOGICAL_COUNT,
	SystemInfoProtocol.InfoNames.CPU_CORE_COUNT,
	SystemInfoProtocol.InfoNames.CPU_PHYS_COUNT,
	SystemInfoProtocol.InfoNames.CPU_SPEED,
	SystemInfoProtocol.InfoNames.GPU,
	SystemInfoProtocol.InfoNames.AVAIL_RAM,
	SystemInfoProtocol.InfoNames.NETWORK_TYPE
}

if game:GetEngineFeature("NewSystemInfoFeaturesEnabled") then
	table.insert(SystemInfoProtocol.ALL_INFO_NAMES, SystemInfoProtocol.InfoNames.BATTERY_LEVEL)
	table.insert(SystemInfoProtocol.ALL_INFO_NAMES, SystemInfoProtocol.InfoNames.THERMAL_STATUS)
end

SystemInfoProtocol.__index = SystemInfoProtocol

function SystemInfoProtocol.new(p)
	return (setmetatable({
		messageBus = p or messageBus
	}, SystemInfoProtocol))
end

function SystemInfoProtocol.getSystemInfo(p, p2)
	return p.messageBus.call(p.GET_SYSTEM_INFO_DESCRIPTOR, p2)
end

SystemInfoProtocol.default = SystemInfoProtocol.new()

return SystemInfoProtocol
