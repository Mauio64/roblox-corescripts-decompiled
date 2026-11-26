return function(object)
	local function getPlatformTarget()
		local v5 = Enum.Platform.None

		pcall(function()
			v5 = object:GetPlatform()
		end)

		local v6 = v5 == Enum.Platform.Windows or v5 == Enum.Platform.OSX

		local v7 = v5 == Enum.Platform.IOS or v5 == Enum.Platform.Android or v5 == Enum.Platform.UWP

		local v8 = v5 == Enum.Platform.XBox360
			or v5 == Enum.Platform.XBoxOne
			or v5 == Enum.Platform.PS3
			or v5 == Enum.Platform.PS4
			or game:GetEngineFeature("PlatformEnumPS5") and v5 == Enum.Platform.PS5
			or v5 == Enum.Platform.WiiU

		return v6 and "client" or v7 and "mobile" or v8 and "console" or "unknownLua" .. tostring(v5)
	end

	return getPlatformTarget
end
