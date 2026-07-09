local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local SetBodyColorViewSetting = require(Modules.AvatarExperience.AvatarEditor.Actions.SetBodyColorViewSetting)
local SetRangeIdToBodyPartsToSliderAndColor3Values = require(Modules.AvatarExperience.AvatarEditor.Actions.SetRangeIdToBodyPartsToSliderAndColor3Values)
local SetSelectedBodyPartIndex = require(Modules.AvatarExperience.AvatarEditor.Actions.SetSelectedBodyPartIndex)

require(Modules.AvatarExperience.Common.Types)

local t1 = {
	viewSetting = "Standard",
	selectedBodyPartIndex = 1,
	rangeIdToBodyPartsToSliderAndColor3Values = {}
}

return Rodux.createReducer(t1, {
	[SetRangeIdToBodyPartsToSliderAndColor3Values.name] = function(p1, p2) -- line: 27
		-- upvalues: Cryo (copy)
		local rangeIdToBodyPartsToSliderAndColor3Values = p1.rangeIdToBodyPartsToSliderAndColor3Values
		local v12 = rangeIdToBodyPartsToSliderAndColor3Values[p2.rangeId] or {}
		local v13 = Cryo.Dictionary.join(v12, {
			[p2.bodyPartForSkinColoringId] = {
				color3 = p2.color3,
				sliderValue = p2.sliderValue
			}
		})

		return Cryo.Dictionary.join(p1, {
			rangeIdToBodyPartsToSliderAndColor3Values = Cryo.Dictionary.join(rangeIdToBodyPartsToSliderAndColor3Values, {
				[p2.rangeId] = v13
			})
		})
	end,
	[SetSelectedBodyPartIndex.name] = function(p3, p4) -- line: 49
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			selectedBodyPartIndex = p4.selectedBodyPartIndex
		})
	end,
	[SetBodyColorViewSetting.name] = function(p5, p6) -- line: 58
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			viewSetting = p6.bodyColorViewSetting
		})
	end
})
