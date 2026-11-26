local defineFastInt = game:DefineFastInt("ReactLowEndMemoryCutoff", 3500)
local defineFastInt2 = game:DefineFastInt("ReactHighEndMemoryCutoff", 7500)

local systemInfoProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/Devices/SystemInfoProtocol").SystemInfoProtocol

local v5 = { LowEnd = "LowEnd", MidTier = "MidTier", HighEnd = "HighEnd" }

return {
	GetDeviceMemoryTier = function(): nil | string
		local success, result = pcall(function()
			return systemInfoProtocol.default:getSystemInfo({ systemInfoProtocol.InfoNames.MAX_MEMORY })
		end)

		if not success or typeof(result) ~= "table" then
			return nil
		end

		local v6 = tonumber(result[systemInfoProtocol.InfoNames.MAX_MEMORY])

		if not v6 then
			return nil
		end

		if v6 <= defineFastInt then
			return "LowEnd"
		end

		if defineFastInt2 <= v6 then
			return "HighEnd"
		end

		return "MidTier"
	end
}
