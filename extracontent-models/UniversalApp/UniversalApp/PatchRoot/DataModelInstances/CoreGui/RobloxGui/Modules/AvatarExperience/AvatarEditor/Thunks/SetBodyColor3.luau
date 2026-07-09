local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FFlagAXColorAdjustmentButtonShouldAccountForTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

require(Modules.AvatarExperience.Common.Types)

local v7 = if not FFlagAXColorAdjustmentButtonShouldAccountForTryOns then require(Modules.AvatarExperience.Common.Selectors.selectHasBodyTryOn) else AvatarExperienceCommon.State.Selectors.selectHasBodyTryOn
local v8 = if not FFlagAXColorAdjustmentButtonShouldAccountForTryOns then require(Modules.AvatarExperience.Common.Selectors.selectAvatarPreviewColors) else AvatarExperienceCommon.State.Selectors.selectAvatarPreviewColors
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SetBodyPartRangeIds = require(Modules.AvatarExperience.AvatarEditor.Actions.SetBodyPartRangeIds)
local SetBodyColor3s = require(Modules.AvatarExperience.AvatarEditor.Actions.SetBodyColor3s)
local TryOnColorUpdated = AvatarExperienceRodux.Actions.TryOnColorUpdated
local SetRangeIdToBodyPartsToSliderAndColor3Values = require(Modules.AvatarExperience.AvatarEditor.Actions.SetRangeIdToBodyPartsToSliderAndColor3Values)
local SendAnalytics = require(Modules.AvatarExperience.AvatarEditor.Thunks.SendAnalytics)

return function(color3: Color3, s1: string, n1: number, p1) -- line: 41
	-- upvalues: Constants (copy), v8 (copy), v7 (copy), TryOnColorUpdated (copy), SetBodyColor3s (copy), SetBodyPartRangeIds (copy), SetRangeIdToBodyPartsToSliderAndColor3Values (copy), SendAnalytics (copy)
	return function(p2) -- line: 42
		-- upvalues: Constants (copy), v8 (copy), color3 (copy), s1 (copy), v7 (copy), TryOnColorUpdated (copy), SetBodyColor3s (copy), SetBodyPartRangeIds (copy), SetRangeIdToBodyPartsToSliderAndColor3Values (copy), n1 (copy), SendAnalytics (copy), p1 (copy)
		local v20 = p2:getState()
		local AvatarEditor = v20.AvatarExperience.AvatarEditor
		local selectedBodyPartIndex = AvatarEditor.BodyColorPickerSettings.selectedBodyPartIndex
		local bodyPartForSkinColoringIds = Constants.BodyPartButtonData[selectedBodyPartIndex].bodyPartForSkinColoringIds
		local v24 = v8(v20)
		local BodyPartRangeIds = AvatarEditor.Character.BodyPartRangeIds
		local t1 = {}
		local t2 = {}

		if bodyPartForSkinColoringIds and #bodyPartForSkinColoringIds > 0 then
			t1 = table.clone(v24)
			t2 = table.clone(BodyPartRangeIds)

			for _, v29 in bodyPartForSkinColoringIds do
				t1[v29] = color3
				t2[v29] = s1
			end
		else
			for _, v31 in Constants.allBodyPartForSkinColoringIds do
				t1[v31] = color3
				t2[v31] = s1
			end
		end

		if v7(v20) then
			p2:dispatch(TryOnColorUpdated(t1, t2))
		else
			p2:dispatch(SetBodyColor3s(t1))
			p2:dispatch(SetBodyPartRangeIds(t2))
		end

		for _, v33 in bodyPartForSkinColoringIds do
			p2:dispatch(SetRangeIdToBodyPartsToSliderAndColor3Values(s1, v33, n1, color3))
		end

		p2:dispatch(SendAnalytics(p1.setBodyColor3s, t1))
	end
end
