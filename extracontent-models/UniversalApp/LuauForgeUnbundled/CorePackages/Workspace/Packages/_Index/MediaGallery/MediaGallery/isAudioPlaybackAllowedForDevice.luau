local systemInfoProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SystemInfoProtocol").SystemInfoProtocol

local fStringLuaAppEdpAudioManufacturerDenyList = require("@game/CorePackages/Workspace/Packages/_Workspace/MediaGallery/SharedFlags").FStringLuaAppEdpAudioManufacturerDenyList

local v5 = nil

local function isAudioPlaybackAllowedForDevice()
	if v5 ~= nil then
		return v5
	end

	v5 = true

	pcall(function()
		local systemInfo = systemInfoProtocol.default:getSystemInfo({ systemInfoProtocol.InfoNames.MANUFACTURER })

		if typeof(systemInfo.manufacturer) == "string" then
			for k in fStringLuaAppEdpAudioManufacturerDenyList:gmatch("(%w+)") do
				if not (typeof(k) == "string" and string.lower(k) == string.lower(systemInfo.manufacturer)) then
					continue
				end

				v5 = false
			end
		end
	end)

	return v5
end

return isAudioPlaybackAllowedForDevice
