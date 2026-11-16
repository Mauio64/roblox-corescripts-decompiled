local parent = script:FindFirstAncestor("Home").Parent

local DiscoveryUtils = require(parent.DiscoveryUtils)
local AddSystemInfoToArgs = DiscoveryUtils.AddSystemInfoToArgs

local v = {
	cpuCores = "cpucore",
	deviceManufacturer = "manufacturer",
	if64Bit = "if_64bit",
	maxMemory = "deviceram",
	systemVersion = "osversion",
	networkType = "networktype",
	cpuMake = "cpu_make",
	cpuSpeed = "cpu_speed",
	GPU = "gpu_adapter",
	availRAM = "avail_ram"
}

local function buildHomeSystemContextFeatures()
	local v2 = {}
	AddSystemInfoToArgs(v2)

	local homeSystemContextFeatures = {}

	for k, v3 in v do
		local v4 = v2[k]

		if v4 ~= nil and v4 ~= "" then
			homeSystemContextFeatures[v3] = tostring(v4)
		end
	end

	local maxResolution = v2.maxResolution

	if typeof(maxResolution) ~= "string" then
		return homeSystemContextFeatures
	end

	local screenwidth, screenheight = string.match(maxResolution, "^(%d+)x(%d+)$")

	if screenwidth and screenheight then
		homeSystemContextFeatures.screenwidth = screenwidth
		homeSystemContextFeatures.screenheight = screenheight
	end

	return homeSystemContextFeatures
end

return buildHomeSystemContextFeatures
