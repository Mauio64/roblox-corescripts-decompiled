local Parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local SystemInfoProtocol = require(Parent.SystemInfoProtocol).SystemInfoProtocol
local ArgCheck = require(Parent.ArgCheck)
local t1 = {
	[SystemInfoProtocol.InfoNames.MANUFACTURER] = "deviceManufacturer",
	[SystemInfoProtocol.InfoNames.BASE_OS] = "operatingSystemVersion",
	[SystemInfoProtocol.InfoNames.IS_64BIT] = "if64Bit",
	[SystemInfoProtocol.InfoNames.CPU_CORE_COUNT] = "cpuCores"
}

return function(t2: {[any]: any}, t3: {[any]: any}?) -- line: 16
	-- upvalues: SystemInfoProtocol (copy), t1 (copy), ArgCheck (copy)
	local v7 = t3 or SystemInfoProtocol.ALL_INFO_NAMES
	local ok, result = pcall(function() -- line: 19
		-- upvalues: SystemInfoProtocol (copy), v7 (copy)
		return SystemInfoProtocol.default:getSystemInfo(v7)
	end)

	if ok and typeof(result) == "table" then
		for k, v in pairs(result) do
			local v12 = t1[k] or k

			ArgCheck.assert(t2[v12] == nil, "Field '" .. tostring(v12) .. "' already exists in argument table!  Will be overwritten.")
			t2[v12] = v
		end
	end
end
