return function(object)
	local function getPlatformTarget()
		local v = Enum.Platform.None

		pcall(function()
			v = object:GetPlatform()
		end)

		local v2 = v == Enum.Platform.Windows or v == Enum.Platform.OSX

		local v3 = v == Enum.Platform.IOS or v == Enum.Platform.Android or v == Enum.Platform.UWP

		local v4 = v == Enum.Platform.XBox360
			or v == Enum.Platform.XBoxOne
			or v == Enum.Platform.PS3
			or v == Enum.Platform.PS4
			or game:GetEngineFeature("PlatformEnumPS5") and v == Enum.Platform.PS5
			or v == Enum.Platform.WiiU

		return v2 and "client" or v3 and "mobile" or v4 and "console" or "unknownLua" .. tostring(v)
	end

	return getPlatformTarget
end
