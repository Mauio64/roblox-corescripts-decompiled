game:DefineFastString("AdPlayerExitButton", "icons/navigation/close")
game:DefineFastString("AdDropdownButtonDefault", "rbxassetid://85625850440429")
game:DefineFastString("AdDropdownButtonOpen", "rbxassetid://85625850440429")
local Flags = {}

function Flags.GetAdPlayerExitButton()
	return game:GetFastString("AdPlayerExitButton")
end

function Flags.GetAdDropdownButtonDefault()
	return game:GetFastString("AdDropdownButtonDefault")
end

function Flags.GetAdDropdownButtonOpen()
	return game:GetFastString("AdDropdownButtonOpen")
end

return Flags
