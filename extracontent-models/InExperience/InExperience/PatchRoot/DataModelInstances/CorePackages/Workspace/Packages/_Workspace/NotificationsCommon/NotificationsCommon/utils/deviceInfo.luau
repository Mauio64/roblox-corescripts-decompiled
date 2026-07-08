local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

return {
	isDesktopDevice = function() -- line: 4
		-- upvalues: UserInputService (copy)
		local None = Enum.Platform.None

		pcall(function() -- line: 6
			-- upvalues: None (ref), UserInputService (copy)
			None = UserInputService:GetPlatform()
		end)

		return None == Enum.Platform.Windows or (None == Enum.Platform.OSX or None == Enum.Platform.UWP)
	end,
	isConsole = function() -- line: 12
		-- upvalues: GuiService (copy)
		return GuiService:IsTenFootInterface()
	end
}
