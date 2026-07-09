return function(p1) -- line: 1
	local function getPlatformTarget() -- line: 2
		-- upvalues: p1 (copy)
		local None = Enum.Platform.None

		pcall(function() -- line: 8
			-- upvalues: None (ref), p1 (copy)
			None = p1:GetPlatform()
		end)

		local v4 = None == Enum.Platform.Windows or None == Enum.Platform.OSX
		local v5 = None == Enum.Platform.IOS or None == Enum.Platform.Android or None == Enum.Platform.UWP
		local v6 = None == Enum.Platform.XBox360 or None == Enum.Platform.XBoxOne or (None == Enum.Platform.PS3 or (None == Enum.Platform.PS4 or game:GetEngineFeature("PlatformEnumPS5") and None == Enum.Platform.PS5)) or None == Enum.Platform.WiiU

		return if not v4 then if not v5 then if not v6 then "unknownLua" .. tostring(None) else "console" else "mobile" else "client"
	end

	return getPlatformTarget
end
