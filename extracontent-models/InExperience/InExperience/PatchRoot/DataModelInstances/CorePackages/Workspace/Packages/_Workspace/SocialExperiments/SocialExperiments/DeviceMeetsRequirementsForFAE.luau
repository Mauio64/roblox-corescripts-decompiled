local parent = script:FindFirstAncestor("SocialExperiments").Parent
local SystemInfoProtocol = require(parent.SystemInfoProtocol)
local systemInfoProtocol = SystemInfoProtocol.SystemInfoProtocol
local FFlagTestDeviceForFAEUpsell = require(script.Parent.FFlagTestDeviceForFAEUpsell)
local defineFastString = game:DefineFastString("FAEUpsellDeviceNamePipeDenyList", "")
local defineFastString2 = game:DefineFastString("FAEUpsellSystemVersionPipeDenyList", "")

local v = nil
local function deviceMeetsRequirementsForFAE()
	if not FFlagTestDeviceForFAEUpsell then
		return true
	end

	if v ~= nil then
		return v
	end

	local success, result = pcall(function()
		local v2 = {
			systemInfoProtocol.InfoNames.DEVICE_NAME,
			systemInfoProtocol.InfoNames.SYSTEM_VERSION,
			systemInfoProtocol.InfoNames.BASE_OS
		}

		local systemInfo = systemInfoProtocol.default:getSystemInfo(v2)
		local deviceName = systemInfo.deviceName or "Unknown"

		if typeof(deviceName) == "string" then
			for k in defineFastString:gmatch("([^|]+)") do
				if deviceName:lower():find(k:lower()) then
					v = false
					return v
				end
			end
		end

		local v3 = (systemInfo.baseOs or "UnknownOS") .. ":" .. (systemInfo.systemVersion or "UnknownVersion")

		if typeof(v3) == "string" then
			for k in defineFastString2:gmatch("([^|]+)") do
				if v3:lower():find(k:lower()) then
					v = false
					return v
				end
			end
		end

		v = true
		return v
	end)
	return not success or result
end

return deviceMeetsRequirementsForFAE
