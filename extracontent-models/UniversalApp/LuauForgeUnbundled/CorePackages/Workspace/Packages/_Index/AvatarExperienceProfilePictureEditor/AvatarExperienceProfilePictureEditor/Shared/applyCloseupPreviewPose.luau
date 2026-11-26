local emoteUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Thumbnailing").EmoteUtility

local function applyCloseupPreviewPose(instance, p2)
	local v5 = if p2 then tonumber(p2) else nil
	local keyframesForPose = emoteUtility.LoadKeyframesForPose(instance, v5, nil, true, true)

	if keyframesForPose then
		emoteUtility.ApplyKeyframesForPose(instance, keyframesForPose)
	else
		emoteUtility.SetPlayerCharacterNeutralPose(instance)
		local humanoid = instance:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 then
			emoteUtility.AdjustArmOnR6ForTool(instance)
		end
	end

	local RunService = game:GetService("RunService")
	RunService.PreAnimation:Wait()
	RunService.PostSimulation:Wait()
end

return applyCloseupPreviewPose
