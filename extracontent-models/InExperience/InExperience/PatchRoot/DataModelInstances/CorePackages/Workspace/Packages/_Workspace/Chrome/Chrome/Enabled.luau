local Parent = script:FindFirstAncestor("Chrome").Parent
local SharedFlags = require(Parent.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagExperienceMenuGamepadExposureEnabled = SharedFlags.FFlagExperienceMenuGamepadExposureEnabled

game:DefineFastFlag("EnableInGameMenuChrome", false)

local v5 = game:DefineFastFlag("DebugEnableChromeOnUnsupportedDevices", false)
local VRService = game:GetService("VRService")
local v7 = game:GetService("GuiService"):IsTenFootInterface()
local isInExperienceUIVREnabled = require(Parent.SharedExperimentDefinition).isInExperienceUIVREnabled

return function() -- line: 18
	-- upvalues: v5 (copy), VRService (copy), isInExperienceUIVREnabled (copy), FFlagExperienceMenuGamepadExposureEnabled (copy), v7 (copy), FFlagEnableConsoleExpControls (copy)
	if v5 then
		return true
	end

	if VRService.VREnabled then
		if isInExperienceUIVREnabled then
			return true
		end

		return false
	end

	if FFlagExperienceMenuGamepadExposureEnabled then
		return true
	end

	if v7 and not FFlagEnableConsoleExpControls then
		return false
	end

	return game:GetFastFlag("EnableInGameMenuChrome")
end
