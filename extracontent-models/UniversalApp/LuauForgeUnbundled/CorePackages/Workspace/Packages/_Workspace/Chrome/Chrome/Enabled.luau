local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/SharedFlags")

local fFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local fFlagExperienceMenuGamepadExposureEnabled = SharedFlags.FFlagExperienceMenuGamepadExposureEnabled

game:DefineFastFlag("EnableInGameMenuChrome", false)
local defineFastFlag = game:DefineFastFlag("DebugEnableChromeOnUnsupportedDevices", false)

local VRService = game:GetService("VRService")
local tenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/AppCommonLib").isTenFootInterface()
local isInExperienceUIVREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/SharedExperimentDefinition").isInExperienceUIVREnabled

return function()
	if defineFastFlag then
		return true
	end

	if VRService.VREnabled then
		if isInExperienceUIVREnabled then
			return true
		end

		return false
	end

	if fFlagExperienceMenuGamepadExposureEnabled then
		return true
	end

	if tenFootInterface and not fFlagEnableConsoleExpControls then
		return false
	end

	return game:GetFastFlag("EnableInGameMenuChrome")
end
