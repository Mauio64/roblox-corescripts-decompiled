local CorePackages = game:GetService("CorePackages")

require("@luauforge/bundled/dHK")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagAXColorAdjustmentButtonShouldAccountForTryOns = AvatarExperienceFlags.FFlagAXColorAdjustmentButtonShouldAccountForTryOns
local fFlagAXUseSignalsForBodyColorPickerSettings = AvatarExperienceFlags.FFlagAXUseSignalsForBodyColorPickerSettings
local v5

if fFlagAXUseSignalsForBodyColorPickerSettings then
	v5 = require("@luauforge/bundled/gOv")
else
	v5 = nil
end

local SignalsExperimental = require(CorePackages.Packages.SignalsExperimental)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module3 = require("@luauforge/bundled/dHL")
require("@luauforge/bundled/dMc")
local v6

if fFlagAXColorAdjustmentButtonShouldAccountForTryOns then
	v6 = AvatarExperienceCommon.State.Selectors.selectHasBodyTryOn
else
	v6 = require("@luauforge/bundled/gOz")
end

local v7

if fFlagAXColorAdjustmentButtonShouldAccountForTryOns then
	v7 = AvatarExperienceCommon.State.Selectors.selectAvatarPreviewColors
else
	v7 = require("@luauforge/bundled/gOy")
end

local module4 = require("@luauforge/bundled/dNQ")
local module5 = require("@luauforge/bundled/dNU")
local module6 = require("@luauforge/bundled/dNW")
local tryOnColorUpdated = module3.Actions.TryOnColorUpdated

local module7 = require("@luauforge/bundled/dPo")
local module8 = require("@luauforge/deferred/gOC")

return function(p2, p3, p4, p5)
	return function(object)
		local state = object:getState()
		local avatarEditor = state.AvatarExperience.AvatarEditor

		local v8 = if fFlagAXUseSignalsForBodyColorPickerSettings then v5(false).getSelectedBodyPartIndex(false) else avatarEditor.BodyColorPickerSettings.selectedBodyPartIndex

		local bodyPartForSkinColoringIds = module4.BodyPartButtonData[v8].bodyPartForSkinColoringIds

		local v9 = v7(state)
		local bodyPartRangeIds = avatarEditor.Character.BodyPartRangeIds

		local v10 = {}
		local v11 = {}

		if bodyPartForSkinColoringIds and #bodyPartForSkinColoringIds > 0 then
			v10 = table.clone(v9)
			v11 = table.clone(bodyPartRangeIds)

			for k, bodyPartForSkinColoringId in bodyPartForSkinColoringIds do
				v10[bodyPartForSkinColoringId] = p2
				v11[bodyPartForSkinColoringId] = p3
			end
		else
			for k, allBodyPartForSkinColoringId in module4.allBodyPartForSkinColoringIds do
				v10[allBodyPartForSkinColoringId] = p2
				v11[allBodyPartForSkinColoringId] = p3
			end
		end

		if v6(state) then
			object:dispatch(tryOnColorUpdated(v10, v11))
		else
			object:dispatch(module6(v10))

			object:dispatch(module5(v11))
		end

		if fFlagAXUseSignalsForBodyColorPickerSettings then
			local v12 = v5(false)
			SignalsExperimental.batch(function()
				for k, bodyPartForSkinColoringId in bodyPartForSkinColoringIds do
					v12.setRangeIdToBodyPartsToSliderAndColor3Values(p3, bodyPartForSkinColoringId, p4, p2)
				end
			end)
		else
			for k, bodyPartForSkinColoringId in bodyPartForSkinColoringIds do
				object:dispatch(module7(p3, bodyPartForSkinColoringId, p4, p2))
			end
		end

		object:dispatch(module8(p5.setBodyColor3s, v10))
	end
end
