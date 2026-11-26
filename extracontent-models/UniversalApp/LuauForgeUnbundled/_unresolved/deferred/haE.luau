local CorePackages = game:GetService("CorePackages")

require("@luauforge/bundled/dKT")

local fFlagAXUseSignalsForBodyColorPickerSettings = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForBodyColorPickerSettings
local v5

if fFlagAXUseSignalsForBodyColorPickerSettings then
	v5 = require("@luauforge/bundled/haA")
else
	v5 = nil
end

local SignalsExperimental = require(CorePackages.Packages.SignalsExperimental)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/dKU")
require("@luauforge/bundled/dPs")
local selectHasBodyTryOn = AvatarExperienceCommon.State.Selectors.selectHasBodyTryOn
local selectAvatarPreviewColors = AvatarExperienceCommon.State.Selectors.selectAvatarPreviewColors

local module3 = require("@luauforge/bundled/dRg")
local module4 = require("@luauforge/bundled/dRk")
local module5 = require("@luauforge/bundled/dRm")
local tryOnColorUpdated = module2.Actions.TryOnColorUpdated

local module6 = require("@luauforge/bundled/dSE")
local module7 = require("@luauforge/deferred/haF")

return function(p2, p3, p4, p5)
	return function(object)
		local state = object:getState()
		local avatarEditor = state.AvatarExperience.AvatarEditor

		local v6 = if fFlagAXUseSignalsForBodyColorPickerSettings then v5(false).getSelectedBodyPartIndex(false) else avatarEditor.BodyColorPickerSettings.selectedBodyPartIndex

		local bodyPartForSkinColoringIds = module3.BodyPartButtonData[v6].bodyPartForSkinColoringIds

		local v7 = selectAvatarPreviewColors(state)
		local bodyPartRangeIds = avatarEditor.Character.BodyPartRangeIds

		local v8 = {}
		local v9 = {}

		if bodyPartForSkinColoringIds and #bodyPartForSkinColoringIds > 0 then
			v8 = table.clone(v7)
			v9 = table.clone(bodyPartRangeIds)

			for k, bodyPartForSkinColoringId in bodyPartForSkinColoringIds do
				v8[bodyPartForSkinColoringId] = p2
				v9[bodyPartForSkinColoringId] = p3
			end
		else
			for k, allBodyPartForSkinColoringId in module3.allBodyPartForSkinColoringIds do
				v8[allBodyPartForSkinColoringId] = p2
				v9[allBodyPartForSkinColoringId] = p3
			end
		end

		if selectHasBodyTryOn(state) then
			object:dispatch(tryOnColorUpdated(v8, v9))
		else
			object:dispatch(module5(v8))

			object:dispatch(module4(v9))
		end

		if fFlagAXUseSignalsForBodyColorPickerSettings then
			local v10 = v5(false)
			SignalsExperimental.batch(function()
				for k, bodyPartForSkinColoringId in bodyPartForSkinColoringIds do
					v10.setRangeIdToBodyPartsToSliderAndColor3Values(p3, bodyPartForSkinColoringId, p4, p2)
				end
			end)
		else
			for k, bodyPartForSkinColoringId in bodyPartForSkinColoringIds do
				object:dispatch(module6(p3, bodyPartForSkinColoringId, p4, p2))
			end
		end

		object:dispatch(module7(p5.setBodyColor3s, v8))
	end
end
