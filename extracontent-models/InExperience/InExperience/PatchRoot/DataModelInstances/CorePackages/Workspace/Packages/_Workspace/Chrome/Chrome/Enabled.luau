local parent = script:FindFirstAncestor("Chrome").Parent

local SharedFlags = require(parent.SharedFlags)

local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagExperienceMenuGamepadExposureEnabled = SharedFlags.FFlagExperienceMenuGamepadExposureEnabled

game:DefineFastFlag("EnableInGameMenuChrome", false)
local defineFastFlag = game:DefineFastFlag("DebugEnableChromeOnUnsupportedDevices", false)

local VRService = game:GetService("VRService")
local AppCommonLib = require(parent.AppCommonLib)
local tenFootInterface = AppCommonLib.isTenFootInterface()
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled

return function()
	if defineFastFlag then
		return true
	end

	if VRService.VREnabled then
		return if isInExperienceUIVREnabled then true else false
	end

	if FFlagExperienceMenuGamepadExposureEnabled then
		return true
	end

	if tenFootInterface and not FFlagEnableConsoleExpControls then
		return false
	end

	return game:GetFastFlag("EnableInGameMenuChrome")
end
