local Players = game:GetService("Players")
local VRService = game:GetService("VRService")
local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

game:DefineFastInt("NewInGameMenuPercentRollout3", 0)
game:DefineFastString("NewInGameMenuForcedUserIds", "")
game:DefineFastFlag("NewInGameMenuDisabledInVR", false)
game:GetService("CoreGui"):WaitForChild("RobloxGui")

local _ = SharedFlags.isSubjectToDesktopPolicies
local isInExperienceUIVREnabled = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).isInExperienceUIVREnabled

return function() -- line: 20
	-- upvalues: VRService (copy), isInExperienceUIVREnabled (copy), Players (copy)
	if VRService.VREnabled then
		if isInExperienceUIVREnabled then
			return false
		end

		return true
	end

	local LocalPlayer = Players.LocalPlayer

	while not LocalPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		LocalPlayer = Players.LocalPlayer
	end

	for match in game:GetFastString("NewInGameMenuForcedUserIds"):gmatch("%d+") do
		if tonumber(match) == LocalPlayer.UserId then
			return true
		end
	end

	if game:GetFastInt("NewInGameMenuPercentRollout3") > LocalPlayer.UserId % 100 then
		return true
	end

	return false
end
