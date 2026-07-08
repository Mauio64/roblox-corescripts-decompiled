game:DefineFastFlag("DebugVRModeInStudio", false)

local function isVRModeInStudio() -- line: 4
	return game:GetFastFlag("DebugVRModeInStudio") and UserSettings().GameSettings:InStudioMode()
end

return isVRModeInStudio
