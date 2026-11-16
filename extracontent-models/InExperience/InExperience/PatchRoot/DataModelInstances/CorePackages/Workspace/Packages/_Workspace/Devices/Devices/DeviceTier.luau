local defineFastInt = game:DefineFastInt("ReactLowEndMemoryCutoff", 3500)
local defineFastInt2 = game:DefineFastInt("ReactHighEndMemoryCutoff", 7500)

local parent = script:FindFirstAncestor("Devices").Parent
local SystemInfoProtocol = require(parent.SystemInfoProtocol)
local systemInfoProtocol = SystemInfoProtocol.SystemInfoProtocol

local _ = { LowEnd = "LowEnd", MidTier = "MidTier", HighEnd = "HighEnd" }

return {
	GetDeviceMemoryTier = function(): nil | string
		local success, result = pcall(function()
			return systemInfoProtocol.default:getSystemInfo({ systemInfoProtocol.InfoNames.MAX_MEMORY })
		end)

		if not success or typeof(result) ~= "table" then
			return nil
		end

		local v = tonumber(result[systemInfoProtocol.InfoNames.MAX_MEMORY])

		if not v then
			return nil
		end

		if v <= defineFastInt then
			return "LowEnd"
		end

		return if defineFastInt2 <= v then "HighEnd" else "MidTier"
	end
}
