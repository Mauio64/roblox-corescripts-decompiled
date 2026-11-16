game:DefineFastFlag("DebugVRModeInStudio", false)

local function isVRModeInStudio()
	return game:GetFastFlag("DebugVRModeInStudio") and UserSettings().GameSettings:InStudioMode()
end

return isVRModeInStudio
