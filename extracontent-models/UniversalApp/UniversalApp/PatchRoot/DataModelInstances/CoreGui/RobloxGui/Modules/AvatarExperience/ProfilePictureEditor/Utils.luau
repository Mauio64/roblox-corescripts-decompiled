local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Modules = CoreGui.RobloxGui.Modules
local GetAvatarEditorStructure = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorStructure)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.ProfilePictureEditor.Constants)
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)
local getEmotesCategory = require(Modules.AvatarExperience.Common.getEmotesCategory)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local GetFFlagAXExtractEmotesCategory = require(Modules.AvatarExperience.Flags.GetFFlagAXExtractEmotesCategory)
local t1 = {}
local t2 = {
	PPEThumbnailType.Closeup,
	PPEThumbnailType.FullBody
}

function t1.ConvertThumbnailTypeToInt(p1) -- line: 25
	-- upvalues: t2 (copy)
	return table.find(t2, p1)
end
function t1.ConvertThumbnailTypeToEnum(p2) -- line: 29
	-- upvalues: PPEThumbnailType (copy)
	if p2 == PPEThumbnailType.Closeup then
		return Enum.AvatarThumbnailCustomizationType.Closeup
	end

	return Enum.AvatarThumbnailCustomizationType.FullBody
end
function t1.isPPEScreenUsingPeekabooWidget(p3) -- line: 37
	-- upvalues: AvatarScreen (copy)
	return p3 == AvatarScreen.ProfilePictureEditorCamera or p3 == AvatarScreen.ProfilePictureEditorFinal
end
function t1.getEmotesCategorySubcategoryAndInfo() -- line: 41
	-- upvalues: GetFFlagAXExtractEmotesCategory (copy), getEmotesCategory (copy), GetAvatarEditorStructure (copy), Constants (copy), Utils (copy)
	if GetFFlagAXExtractEmotesCategory() then
		return nil, nil, (getEmotesCategory())
	end

	local v17 = GetAvatarEditorStructure().AssetTypeToCategorySubcategory[Constants.AssetTypeIdStrings.EmoteAnimation]
	local category = v17.category
	local subcategory = v17.subcategory

	return category, subcategory, (Utils.getAvatarEditorCategoryInfo(category, subcategory))
end
function t1.getSliderValueFromYRotDeg(n1: number) -- line: 55
	-- upvalues: Constants2 (copy)
	return (math.clamp(n1 * Constants2.SliderMax / Constants2.YRotMaxDeg, -Constants2.SliderMax, Constants2.SliderMax))
end
function t1.getYRotDegFromSliderValue(n2: number) -- line: 63
	-- upvalues: Constants2 (copy)
	return (math.clamp(n2 * Constants2.YRotMaxDeg / Constants2.SliderMax, -Constants2.YRotMaxDeg, Constants2.YRotMaxDeg))
end
function t1.getCameraDistanceScaleFromSliderValue(p4) -- line: 71
	-- upvalues: Constants2 (copy)
	local v23 = -p4 / Constants2.SliderMax + 1

	return (1 - Constants2.ZoomMinScale) * v23 * v23 + Constants2.ZoomMinScale
end
function t1.getSliderValueFromCameraDistanceScale(n3: number) -- line: 82
	-- upvalues: Constants2 (copy)
	return (math.clamp((math.sqrt((n3 - Constants2.ZoomMinScale) / (1 - Constants2.ZoomMinScale)) - 1) * -Constants2.SliderMax, -Constants2.SliderMax, Constants2.SliderMax))
end

return t1
