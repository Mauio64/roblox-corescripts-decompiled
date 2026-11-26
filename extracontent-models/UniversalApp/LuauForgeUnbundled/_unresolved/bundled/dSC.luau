local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
require("@luauforge/bundled/dKU")

local module = require("@luauforge/bundled/dSD")

local module2 = require("@luauforge/bundled/dSE")
local module3 = require("@luauforge/bundled/dSG")
require("@luauforge/bundled/dPs")

return Rodux.createReducer(
	{
		viewSetting = "Standard",
		rangeIdToBodyPartsToSliderAndColor3Values = {},
		selectedBodyPartIndex = 1
	},
	{
		[module2.name] = function(p2, data)
			local rangeIdToBodyPartsToSliderAndColor3Values = p2.rangeIdToBodyPartsToSliderAndColor3Values
			local v6 = rangeIdToBodyPartsToSliderAndColor3Values[data.rangeId] or {}
			local v8 = Cryo.Dictionary.join(v6, {
				[data.bodyPartForSkinColoringId] = {
					color3 = data.color3,
					sliderValue = data.sliderValue
				}
			})

			return Cryo.Dictionary.join(p2, {
				rangeIdToBodyPartsToSliderAndColor3Values = Cryo.Dictionary.join(
					rangeIdToBodyPartsToSliderAndColor3Values,
					{ [data.rangeId] = v8 }
				)
			})
		end,
		[module3.name] = function(p2, p3)
			return Cryo.Dictionary.join(p2, {
				selectedBodyPartIndex = p3.selectedBodyPartIndex
			})
		end,
		[module.name] = function(p2, p3)
			return Cryo.Dictionary.join(p2, { viewSetting = p3.bodyColorViewSetting })
		end
	}
)
