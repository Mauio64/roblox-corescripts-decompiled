local SocialExperiments = script:FindFirstAncestor("SocialExperiments")
local parent = SocialExperiments.Parent

local SystemInfoProtocol = require(parent.SystemInfoProtocol)
local systemInfoProtocol = SystemInfoProtocol.SystemInfoProtocol

require(SocialExperiments.DeviceGateFeature)

local enabledsByFeatureName = {}
local v = {}

return function(data)
	if enabledsByFeatureName[data.featureName] == nil then
		enabledsByFeatureName[data.featureName] = data.enabled
	end

	if enabledsByFeatureName[data.featureName] then
		if v[data.featureName] == nil then
			local _, _ = pcall(function()
				local v2 = {
					systemInfoProtocol.InfoNames.DEVICE_NAME,
					systemInfoProtocol.InfoNames.SYSTEM_VERSION,
					systemInfoProtocol.InfoNames.BASE_OS
				}

				local systemInfo = systemInfoProtocol.default:getSystemInfo(v2)
				local deviceName = systemInfo.deviceName or "UnknownDeviceName"

				if typeof(deviceName) == "string" then
					for k in data.deviceNameBlackListString:gmatch("([^|]+)") do
						if deviceName:lower():find(k:lower()) then
							v[data.featureName] = true
							return v[data.featureName]
						end
					end
				end

				local baseOs = systemInfo.baseOs or "UnknownOS"
				local systemVersion = systemInfo.systemVersion or "UnknownVersion"

				if typeof(baseOs) == "string" and typeof(systemVersion) == "string" then
					local v3 = baseOs .. ":" .. systemVersion

					for k in data.osVersionBlackListString:gmatch("([^|]+)") do
						if v3:lower():find(k:lower()) then
							v[data.featureName] = true
							return v[data.featureName]
						end
					end
				end

				v[data.featureName] = false
				return v[data.featureName]
			end)

			if v[data.featureName] == nil then
				v[data.featureName] = false
			end
		end
	else
		v[data.featureName] = false
	end

	return v[data.featureName]
end
