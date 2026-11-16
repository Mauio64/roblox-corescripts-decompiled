local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent
local Thumbnailing = require(parent.Thumbnailing)
local EmoteUtility = Thumbnailing.EmoteUtility

local function applyCloseupPreviewPose(instance, p: string?)
	local v

	if p then
		v = tonumber(p)
	end

	local keyframesForPose = EmoteUtility.LoadKeyframesForPose(instance, v, nil, true, true)

	if keyframesForPose then
		EmoteUtility.ApplyKeyframesForPose(instance, keyframesForPose)
	else
		EmoteUtility.SetPlayerCharacterNeutralPose(instance)
		local humanoid = instance:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 then
			EmoteUtility.AdjustArmOnR6ForTool(instance)
		end
	end

	local RunService = game:GetService("RunService")
	RunService.PreAnimation:Wait()
	RunService.PostSimulation:Wait()
end

return applyCloseupPreviewPose
