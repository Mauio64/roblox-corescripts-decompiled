local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local SystemInfoProtocol = require(Parent.SystemInfoProtocol).SystemInfoProtocol
local FFlagTestDeviceForFAEUpsell = require(script.Parent.FFlagTestDeviceForFAEUpsell)
local v4 = game:DefineFastString("FAEUpsellDeviceNamePipeDenyList", "")
local v5 = game:DefineFastString("FAEUpsellSystemVersionPipeDenyList", "")
local u6 = nil

local function deviceMeetsRequirementsForFAE() -- line: 9
	-- upvalues: FFlagTestDeviceForFAEUpsell (copy), u6 (ref), SystemInfoProtocol (copy), v4 (copy), v5 (copy)
	if not FFlagTestDeviceForFAEUpsell then
		return true
	end

	if u6 ~= nil then
		return u6
	end

	local ok, result = pcall(function() -- line: 16
		-- upvalues: SystemInfoProtocol (copy), v4 (copy), u6 (ref), v5 (copy)
		local t1 = {
			SystemInfoProtocol.InfoNames.DEVICE_NAME,
			SystemInfoProtocol.InfoNames.SYSTEM_VERSION,
			SystemInfoProtocol.InfoNames.BASE_OS
		}
		local v11 = SystemInfoProtocol.default:getSystemInfo(t1)
		local v12 = v11.deviceName or "Unknown"

		if typeof(v12) == "string" then
			for match in v4:gmatch("([^|]+)") do
				if v12:lower():find(match:lower()) then
					u6 = false

					return u6
				end
			end
		end

		local v14 = (v11.baseOs or "UnknownOS") .. ":" .. (v11.systemVersion or "UnknownVersion")

		if typeof(v14) == "string" then
			for match in v5:gmatch("([^|]+)") do
				if v14:lower():find(match:lower()) then
					u6 = false

					return u6
				end
			end
		end

		u6 = true

		return u6
	end)

	if ok then
		return result
	end

	return true
end

return deviceMeetsRequirementsForFAE
