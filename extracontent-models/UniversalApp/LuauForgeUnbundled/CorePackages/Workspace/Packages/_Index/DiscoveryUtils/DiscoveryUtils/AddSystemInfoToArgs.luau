local systemInfoProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryUtils/SystemInfoProtocol").SystemInfoProtocol
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryUtils/ArgCheck")

local v5 = {
	[systemInfoProtocol.InfoNames.MANUFACTURER] = "deviceManufacturer",
	[systemInfoProtocol.InfoNames.BASE_OS] = "operatingSystemVersion",
	[systemInfoProtocol.InfoNames.IS_64BIT] = "if64Bit",
	[systemInfoProtocol.InfoNames.CPU_CORE_COUNT] = "cpuCores"
}

return function(p2, p3)
	local v6 = p3 or systemInfoProtocol.ALL_INFO_NAMES

	local success, result = pcall(function()
		return systemInfoProtocol.default:getSystemInfo(v6)
	end)

	if success and typeof(result) == "table" then
		for k, v7 in pairs(result) do
			local v8 = v5[k] or k
			ArgCheck.assert(
				p2[v8] == nil,
				"Field '" .. tostring(v8) .. "' already exists in argument table!  Will be overwritten."
			)

			p2[v8] = v7
		end
	end
end
