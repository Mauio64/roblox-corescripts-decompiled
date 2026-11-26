local addSystemInfoToArgs = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/DiscoveryUtils").AddSystemInfoToArgs

local v5 = {
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
	local v6 = {}
	addSystemInfoToArgs(v6)

	local homeSystemContextFeatures = {}

	for k, v7 in v5 do
		local v8 = v6[k]

		if v8 ~= nil and v8 ~= "" then
			homeSystemContextFeatures[v7] = tostring(v8)
		end
	end

	local maxResolution = v6.maxResolution

	if typeof(maxResolution) ~= "string" then
		return homeSystemContextFeatures
	end

	local v7, v8 = string.match(maxResolution, "^(%d+)x(%d+)$")

	if v7 and v8 then
		homeSystemContextFeatures.screenwidth = v7
		homeSystemContextFeatures.screenheight = v8
	end

	return homeSystemContextFeatures
end

return buildHomeSystemContextFeatures
