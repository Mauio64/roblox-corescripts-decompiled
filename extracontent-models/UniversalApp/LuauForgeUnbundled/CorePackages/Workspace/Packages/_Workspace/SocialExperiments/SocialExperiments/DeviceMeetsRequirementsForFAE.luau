local systemInfoProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/SystemInfoProtocol").SystemInfoProtocol
local FFlagTestDeviceForFAEUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/SocialExperiments/FFlagTestDeviceForFAEUpsell")
local defineFastString = game:DefineFastString("FAEUpsellDeviceNamePipeDenyList", "")
local defineFastString2 = game:DefineFastString("FAEUpsellSystemVersionPipeDenyList", "")

local v5 = nil
local function deviceMeetsRequirementsForFAE()
	if not FFlagTestDeviceForFAEUpsell then
		return true
	end

	if v5 ~= nil then
		return v5
	end

	local success, result = pcall(function()
		local v6 = {
			systemInfoProtocol.InfoNames.DEVICE_NAME,
			systemInfoProtocol.InfoNames.SYSTEM_VERSION,
			systemInfoProtocol.InfoNames.BASE_OS
		}

		local systemInfo = systemInfoProtocol.default:getSystemInfo(v6)
		local deviceName = systemInfo.deviceName or "Unknown"

		if typeof(deviceName) == "string" then
			for k in defineFastString:gmatch("([^|]+)") do
				if deviceName:lower():find(k:lower()) then
					v5 = false
					return v5
				end
			end
		end

		local v7 = (systemInfo.baseOs or "UnknownOS") .. ":" .. (systemInfo.systemVersion or "UnknownVersion")

		if typeof(v7) == "string" then
			for k in defineFastString2:gmatch("([^|]+)") do
				if v7:lower():find(k:lower()) then
					v5 = false
					return v5
				end
			end
		end

		v5 = true
		return v5
	end)

	if success then
		return result
	end

	return true
end

return deviceMeetsRequirementsForFAE
