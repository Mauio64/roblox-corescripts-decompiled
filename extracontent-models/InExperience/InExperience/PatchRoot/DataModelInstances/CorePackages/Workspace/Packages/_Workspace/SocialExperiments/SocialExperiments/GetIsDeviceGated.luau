local SocialExperiments = script:FindFirstAncestor("SocialExperiments")
local SocialExperimentsParent = SocialExperiments.Parent
local SystemInfoProtocol = require(SocialExperimentsParent.SystemInfoProtocol).SystemInfoProtocol

require(SocialExperiments.DeviceGateFeature)

local t1 = {}
local t2 = {}

return function(t3: {[any]: any}) -- line: 18
	-- upvalues: t1 (copy), t2 (copy), SystemInfoProtocol (copy)
	if t1[t3.featureName] == nil then
		t1[t3.featureName] = t3.enabled
	end

	if t1[t3.featureName] then
		if t2[t3.featureName] == nil then
			local _, _ = pcall(function() -- line: 25
				-- upvalues: SystemInfoProtocol (copy), t3 (copy), t2 (copy)
				local t4 = {
					SystemInfoProtocol.InfoNames.DEVICE_NAME,
					SystemInfoProtocol.InfoNames.SYSTEM_VERSION,
					SystemInfoProtocol.InfoNames.BASE_OS
				}
				local v10 = SystemInfoProtocol.default:getSystemInfo(t4)
				local v11 = v10.deviceName or "UnknownDeviceName"

				if typeof(v11) == "string" then
					for match in t3.deviceNameBlackListString:gmatch("([^|]+)") do
						if v11:lower():find(match:lower()) then
							t2[t3.featureName] = true

							return t2[t3.featureName]
						end
					end
				end

				local v13 = v10.baseOs or "UnknownOS"
				local v14 = v10.systemVersion or "UnknownVersion"

				if typeof(v13) == "string" and typeof(v14) == "string" then
					local v15 = v13 .. ":" .. v14

					for match in t3.osVersionBlackListString:gmatch("([^|]+)") do
						if v15:lower():find(match:lower()) then
							t2[t3.featureName] = true

							return t2[t3.featureName]
						end
					end
				end

				t2[t3.featureName] = false

				return t2[t3.featureName]
			end)

			if t2[t3.featureName] == nil then
				t2[t3.featureName] = false
			end
		end
	else
		t2[t3.featureName] = false
	end

	return t2[t3.featureName]
end
