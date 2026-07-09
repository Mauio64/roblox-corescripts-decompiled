local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ColorVariantsEnum = require(ParentParent.Enums.ColorVariantsEnum)
local useUserExperiment = require(ParentParentParent.RoactAppExperiment).useUserExperiment
local FStringSocialOnboardingExperimentLayer = require(ParentParentParent.SharedFlags).FStringSocialOnboardingExperimentLayer
local v6 = game:DefineFastString("SocialOnboardingEnabledVariableName", "socialOnboardingBtnsEnabled")
local v7 = game:DefineFastString("SocialOnboardingColorVariableName", "socialOnboardingBtnsColor")
local v8 = game:DefineFastString("SocialOnboardingButtonsVariableName", "socialOnboardingButtons")
local v9 = game:DefineFastString("SocialOnboardingHideAfterSignupVariableNam", "hideAfterSignup")

local function v10(p1) -- line: 19
	-- upvalues: FStringSocialOnboardingExperimentLayer (copy), v6 (copy)
	return (p1[FStringSocialOnboardingExperimentLayer] or {})[v6] or false
end
local function v11(p2) -- line: 24
	-- upvalues: FStringSocialOnboardingExperimentLayer (copy), v7 (copy), ColorVariantsEnum (copy)
	return (p2[FStringSocialOnboardingExperimentLayer] or {})[v7] or ColorVariantsEnum.Default
end
local function v12(p3) -- line: 29
	-- upvalues: FStringSocialOnboardingExperimentLayer (copy), v8 (copy)
	return (p3[FStringSocialOnboardingExperimentLayer] or {})[v8] or ""
end
local function v13(p4) -- line: 34
	-- upvalues: FStringSocialOnboardingExperimentLayer (copy), v9 (copy)
	return (p4[FStringSocialOnboardingExperimentLayer] or {})[v9] or false
end

return {
	useSocialOnboardingBtnsEnabled = function() -- line: 40
		-- upvalues: useUserExperiment (copy), FStringSocialOnboardingExperimentLayer (copy), v10 (copy)
		return useUserExperiment({ FStringSocialOnboardingExperimentLayer }, v10)
	end,
	useSocialOnboardingBtnsColor = function() -- line: 43
		-- upvalues: useUserExperiment (copy), FStringSocialOnboardingExperimentLayer (copy), v11 (copy)
		return useUserExperiment({ FStringSocialOnboardingExperimentLayer }, v11)
	end,
	useSocialOnboardingBtnsOrder = function() -- line: 46
		-- upvalues: useUserExperiment (copy), FStringSocialOnboardingExperimentLayer (copy), v12 (copy)
		return useUserExperiment({ FStringSocialOnboardingExperimentLayer }, v12)
	end,
	useSocialOnboardingBtnsHideAfterSignup = function() -- line: 49
		-- upvalues: useUserExperiment (copy), FStringSocialOnboardingExperimentLayer (copy), v13 (copy)
		return useUserExperiment({ FStringSocialOnboardingExperimentLayer }, v13)
	end
}
