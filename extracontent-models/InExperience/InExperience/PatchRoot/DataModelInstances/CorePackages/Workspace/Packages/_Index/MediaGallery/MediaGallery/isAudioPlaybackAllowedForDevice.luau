local parent = script:FindFirstAncestor("MediaGallery").Parent

local SystemInfoProtocol = require(parent.SystemInfoProtocol)
local systemInfoProtocol = SystemInfoProtocol.SystemInfoProtocol

local SharedFlags = require(parent.SharedFlags)
local FStringLuaAppEdpAudioManufacturerDenyList = SharedFlags.FStringLuaAppEdpAudioManufacturerDenyList

local v = nil

local function isAudioPlaybackAllowedForDevice()
	if v ~= nil then
		return v
	end

	v = true

	pcall(function()
		local systemInfo = systemInfoProtocol.default:getSystemInfo({ systemInfoProtocol.InfoNames.MANUFACTURER })

		if typeof(systemInfo.manufacturer) == "string" then
			for k in FStringLuaAppEdpAudioManufacturerDenyList:gmatch("(%w+)") do
				if not (typeof(k) == "string" and string.lower(k) == string.lower(systemInfo.manufacturer)) then
					continue
				end

				v = false
			end
		end
	end)

	return v
end

return isAudioPlaybackAllowedForDevice
