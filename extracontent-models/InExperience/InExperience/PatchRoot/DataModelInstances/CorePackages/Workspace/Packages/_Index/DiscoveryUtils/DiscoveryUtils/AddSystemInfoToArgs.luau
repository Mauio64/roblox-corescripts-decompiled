local parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local SystemInfoProtocol = require(parent.SystemInfoProtocol)
local systemInfoProtocol = SystemInfoProtocol.SystemInfoProtocol
local ArgCheck = require(parent.ArgCheck)

local v = {
	[systemInfoProtocol.InfoNames.MANUFACTURER] = "deviceManufacturer",
	[systemInfoProtocol.InfoNames.BASE_OS] = "operatingSystemVersion",
	[systemInfoProtocol.InfoNames.IS_64BIT] = "if64Bit",
	[systemInfoProtocol.InfoNames.CPU_CORE_COUNT] = "cpuCores"
}

return function(p, p2)
	local v2 = p2 or systemInfoProtocol.ALL_INFO_NAMES

	local success, result = pcall(function()
		return systemInfoProtocol.default:getSystemInfo(v2)
	end)

	if success and typeof(result) == "table" then
		for k, v3 in pairs(result) do
			local v4 = v[k] or k
			ArgCheck.assert(
				p[v4] == nil,
				"Field '" .. tostring(v4) .. "' already exists in argument table!  Will be overwritten."
			)

			p[v4] = v3
		end
	end
end
