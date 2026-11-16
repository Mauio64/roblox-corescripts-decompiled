local Players = game:GetService("Players")
local VRService = game:GetService("VRService")
local CorePackages = game:GetService("CorePackages")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)

game:DefineFastInt("NewInGameMenuPercentRollout3", 0)
game:DefineFastString("NewInGameMenuForcedUserIds", "")
game:DefineFastFlag("NewInGameMenuDisabledInVR", false)

local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")

local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies

local SharedExperimentDefinition = require(CorePackages.Workspace.Packages.SharedExperimentDefinition)
local isInExperienceUIVREnabled = SharedExperimentDefinition.isInExperienceUIVREnabled

return function(): boolean
	if VRService.VREnabled then
		return not isInExperienceUIVREnabled
	else
		local localPlayer = Players.LocalPlayer

		while not localPlayer do
			Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
			localPlayer = Players.LocalPlayer
		end

		for k in game:GetFastString("NewInGameMenuForcedUserIds"):gmatch("%d+") do
			if tonumber(k) == localPlayer.UserId then
				return true
			end
		end

		return game:GetFastInt("NewInGameMenuPercentRollout3") > localPlayer.UserId % 100
	end
end
