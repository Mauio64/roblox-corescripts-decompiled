local CorePackages = game:GetService("CorePackages")

local fFlagAXUseSignalsForBodyColorPickerSettings = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForBodyColorPickerSettings

local v5 = if fFlagAXUseSignalsForBodyColorPickerSettings then require("@luauforge/bundled/gOv") else nil

local SignalsExperimental = require(CorePackages.Packages.SignalsExperimental)
local module = require("@luauforge/bundled/fvh")
require("@luauforge/bundled/dMc")
local module2 = require("@luauforge/bundled/dNU")

local module3 = require("@luauforge/bundled/dPo")

return function(items)
	return function(object)
		local defaultBodyColorRanges = object:getState().AvatarExperience.AvatarEditor.DefaultBodyColorRanges

		assert(defaultBodyColorRanges ~= nil, "defaultBodyColorRanges is nil")

		local rangeAndSliderValueForColor3s = {}
		local v6 = {}

		for k, item in items do
			local rangeAndSliderValueForColor3, v7 = module.findRangeAndSliderValueForColor3(
				item,
				defaultBodyColorRanges
			)
			rangeAndSliderValueForColor3s[k] = rangeAndSliderValueForColor3
			v6[k] = v7
		end

		object:dispatch(module2(rangeAndSliderValueForColor3s))

		if fFlagAXUseSignalsForBodyColorPickerSettings then
			local v7 = v5(false)
			SignalsExperimental.batch(function()
				for k, v8 in v6 do
					v7.setRangeIdToBodyPartsToSliderAndColor3Values(
						rangeAndSliderValueForColor3s[k],
						k,
						v8,
						items[k]
					)
				end
			end)
		else
			for k, v7 in v6 do
				local item = items[k]
				object:dispatch(module3(rangeAndSliderValueForColor3s[k], k, v7, item))
			end
		end
	end
end
