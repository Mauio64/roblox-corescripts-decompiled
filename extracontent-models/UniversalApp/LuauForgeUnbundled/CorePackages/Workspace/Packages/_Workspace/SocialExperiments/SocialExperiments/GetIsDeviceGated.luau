local systemInfoProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/SystemInfoProtocol").SystemInfoProtocol

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/SocialExperiments/DeviceGateFeature")

local enabledsByFeatureName = {}
local v5 = {}

return function(data)
	if enabledsByFeatureName[data.featureName] == nil then
		enabledsByFeatureName[data.featureName] = data.enabled
	end

	if enabledsByFeatureName[data.featureName] then
		if v5[data.featureName] == nil then
			local success, result = pcall(function()
				local v6 = {
					systemInfoProtocol.InfoNames.DEVICE_NAME,
					systemInfoProtocol.InfoNames.SYSTEM_VERSION,
					systemInfoProtocol.InfoNames.BASE_OS
				}

				local systemInfo = systemInfoProtocol.default:getSystemInfo(v6)
				local deviceName = systemInfo.deviceName or "UnknownDeviceName"

				if typeof(deviceName) == "string" then
					for k in data.deviceNameBlackListString:gmatch("([^|]+)") do
						if deviceName:lower():find(k:lower()) then
							v5[data.featureName] = true
							return v5[data.featureName]
						end
					end
				end

				local baseOs = systemInfo.baseOs or "UnknownOS"
				local systemVersion = systemInfo.systemVersion or "UnknownVersion"

				if typeof(baseOs) == "string" and typeof(systemVersion) == "string" then
					local v7 = baseOs .. ":" .. systemVersion

					for k in data.osVersionBlackListString:gmatch("([^|]+)") do
						if v7:lower():find(k:lower()) then
							v5[data.featureName] = true
							return v5[data.featureName]
						end
					end
				end

				v5[data.featureName] = false
				return v5[data.featureName]
			end)

			if v5[data.featureName] == nil then
				v5[data.featureName] = false
			end
		end
	else
		v5[data.featureName] = false
	end

	return v5[data.featureName]
end
