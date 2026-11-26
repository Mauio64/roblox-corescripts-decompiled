local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module = require("@luauforge/bundled/dRy")
local module2 = require("@luauforge/bundled/fCe")
local module3 = require("@luauforge/bundled/dPN")
local module4 = require("@luauforge/bundled/fCW")
local module5 = require("@luauforge/bundled/dWC")
local module6 = require("@luauforge/bundled/dRE")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module7 = require("@luauforge/bundled/dRH")

local v6 = { module5.Closeup, module5.FullBody }
return {
	ConvertThumbnailTypeToInt = function(p2)
		return table.find(v6, p2)
	end,
	ConvertThumbnailTypeToEnum = function(p2)
		if p2 == module5.Closeup then
			return Enum.AvatarThumbnailCustomizationType.Closeup
		end

		return Enum.AvatarThumbnailCustomizationType.FullBody
	end,
	isPPEScreenUsingPeekabooWidget = function(p2): boolean
		return p2 == avatarScreen.ProfilePictureEditorCamera or p2 == avatarScreen.ProfilePictureEditorFinal
	end,
	getEmotesCategorySubcategoryAndInfo = function()
		if module7() then
			return nil, nil, module6()
		end

		local v7 = module().AssetTypeToCategorySubcategory[module3.AssetTypeIdStrings.EmoteAnimation]
		local category = v7.category
		local subcategory = v7.subcategory
		return category, subcategory, (module2.getAvatarEditorCategoryInfo(category, subcategory))
	end,
	getSliderValueFromYRotDeg = function(p2)
		return (math.clamp(
			p2 * module4.SliderMax / module4.YRotMaxDeg,
			-module4.SliderMax,
			module4.SliderMax
		))
	end,
	getYRotDegFromSliderValue = function(p2)
		return (math.clamp(
			p2 * module4.YRotMaxDeg / module4.SliderMax,
			-module4.YRotMaxDeg,
			module4.YRotMaxDeg
		))
	end,
	getCameraDistanceScaleFromSliderValue = function(p2)
		local v7 = -p2 / module4.SliderMax + 1

		return (1 - module4.ZoomMinScale) * v7 * v7 + module4.ZoomMinScale
	end,
	getSliderValueFromCameraDistanceScale = function(p2)
		return (math.clamp(
			(math.sqrt((p2 - module4.ZoomMinScale) / (1 - module4.ZoomMinScale)) - 1) * -module4.SliderMax,
			-module4.SliderMax,
			module4.SliderMax
		))
	end
}
