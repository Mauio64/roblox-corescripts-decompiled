local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local CurveAnimBoneHierarchyUtils = require(parent.util.CurveAnimBoneHierarchyUtils)

local getEngineFeatureIsValidR15Plus = require(parent.flags.getEngineFeatureIsValidR15Plus)

return {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.curveAnimations },
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		for _, curveAnimation in p.curveAnimations do
			local count = 0

			for _, animationRigData in curveAnimation:GetChildren() do
				if not animationRigData:IsA("AnimationRigData") then
					continue
				end

				count += 1

				if count > 1 then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_MultipleRigData)
					return
				end
			end

			if count == 0 then
				object:fail(ErrorSourceStrings.Keys.CurveAnim_NoRigData)
				break
			end

			if CurveAnimBoneHierarchyUtils.hasBoneFolders(curveAnimation) then
				if getEngineFeatureIsValidR15Plus() then
					for _, animationRigData in curveAnimation:GetChildren() do
						if animationRigData:IsA("AnimationRigData") and not animationRigData:IsValidR15Plus() then
							object:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidRigDataR15Plus)
							return
						end
					end
				end
			else
				for _, animationRigData in curveAnimation:GetChildren() do
					if animationRigData:IsA("AnimationRigData") and not animationRigData:IsValidR15() then
						object:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidRigData)
						return
					end
				end
			end
		end
	end
}
