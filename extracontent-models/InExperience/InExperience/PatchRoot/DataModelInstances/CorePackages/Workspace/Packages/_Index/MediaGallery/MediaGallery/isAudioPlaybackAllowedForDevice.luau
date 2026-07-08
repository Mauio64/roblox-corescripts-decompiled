local Parent = script:FindFirstAncestor("MediaGallery").Parent
local SystemInfoProtocol = require(Parent.SystemInfoProtocol).SystemInfoProtocol
local FStringLuaAppEdpAudioManufacturerDenyList = require(Parent.SharedFlags).FStringLuaAppEdpAudioManufacturerDenyList
local u4 = nil

local function isAudioPlaybackAllowedForDevice() -- line: 11
	-- upvalues: u4 (ref), SystemInfoProtocol (copy), FStringLuaAppEdpAudioManufacturerDenyList (copy)
	if u4 ~= nil then
		return u4
	end

	u4 = true
	pcall(function() -- line: 18
		-- upvalues: SystemInfoProtocol (copy), FStringLuaAppEdpAudioManufacturerDenyList (copy), u4 (ref)
		local v6 = SystemInfoProtocol.default:getSystemInfo({ SystemInfoProtocol.InfoNames.MANUFACTURER })

		if typeof(v6.manufacturer) == "string" then
			for match in FStringLuaAppEdpAudioManufacturerDenyList:gmatch("(%w+)") do
				if typeof(match) == "string" and string.lower(match) == string.lower(v6.manufacturer) then
					u4 = false
				end
			end
		end
	end)

	return u4
end

return isAudioPlaybackAllowedForDevice
