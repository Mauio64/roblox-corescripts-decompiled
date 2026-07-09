local v1 = game:DefineFastInt("ReactLowEndMemoryCutoff", 3500)
local v2 = game:DefineFastInt("ReactHighEndMemoryCutoff", 7500)
local Parent = script:FindFirstAncestor("Devices").Parent
local SystemInfoProtocol = require(Parent.SystemInfoProtocol).SystemInfoProtocol
local _ = {
	LowEnd = "LowEnd",
	MidTier = "MidTier",
	HighEnd = "HighEnd"
}

return {
	GetDeviceMemoryTier = function() -- line: 27
		-- upvalues: SystemInfoProtocol (copy), v1 (copy), v2 (copy)
		local ok, result = pcall(function() -- line: 28
			-- upvalues: SystemInfoProtocol (copy)
			return SystemInfoProtocol.default:getSystemInfo({ SystemInfoProtocol.InfoNames.MAX_MEMORY })
		end)

		if ok and typeof(result) == "table" then
			local num = tonumber(result[SystemInfoProtocol.InfoNames.MAX_MEMORY])

			if not num then
				return nil
			end

			if num <= v1 then
				return "LowEnd"
			end

			if num >= v2 then
				return "HighEnd"
			end

			return "MidTier"
		end

		return nil
	end
}
