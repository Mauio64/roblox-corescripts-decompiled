local parent = script.Parent

local getFIntUGCValidationHeadThreshold = require(parent.flags.getFIntUGCValidationHeadThreshold)
local getFIntUGCValidationTorsoThresholdFront = require(parent.flags.getFIntUGCValidationTorsoThresholdFront)
local getFIntUGCValidationTorsoThresholdBack = require(parent.flags.getFIntUGCValidationTorsoThresholdBack)
local getFIntUGCValidationTorsoThresholdSide = require(parent.flags.getFIntUGCValidationTorsoThresholdSide)
local getFIntUGCValidationTorsoThresholdTopBottom = require(parent.flags.getFIntUGCValidationTorsoThresholdTopBottom)
local getFIntUGCValidationArmThresholdFront = require(parent.flags.getFIntUGCValidationArmThresholdFront)
local getFIntUGCValidationArmThresholdBack = require(parent.flags.getFIntUGCValidationArmThresholdBack)
local getFIntUGCValidationArmThresholdSide = require(parent.flags.getFIntUGCValidationArmThresholdSide)
local getFIntUGCValidationArmThresholdTopBottom = require(parent.flags.getFIntUGCValidationArmThresholdTopBottom)
local getFIntUGCValidationLegThresholdFront = require(parent.flags.getFIntUGCValidationLegThresholdFront)
local getFIntUGCValidationLegThresholdBack = require(parent.flags.getFIntUGCValidationLegThresholdBack)
local getFIntUGCValidationLegThresholdSide = require(parent.flags.getFIntUGCValidationLegThresholdSide)
local getFIntUGCValidationLegThresholdTopBottom = require(parent.flags.getFIntUGCValidationLegThresholdTopBottom)

local ConstantsTransparencyValidation = {}

ConstantsTransparencyValidation.CAMERA_ANGLES = {
	Front = "Front",
	Back = "Back",
	Left = "Left",
	Right = "Right",
	Top = "Top",
	Bottom = "Bottom"
}

ConstantsTransparencyValidation.ASSET_TRANSPARENCY_THRESHOLDS = {}

local ASSET_TRANSPARENCY_THRESHOLDS = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_THRESHOLDS
local DynamicHead = Enum.AssetType.DynamicHead
ASSET_TRANSPARENCY_THRESHOLDS[DynamicHead] = {
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Front] = getFIntUGCValidationHeadThreshold() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Back] = getFIntUGCValidationHeadThreshold() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Left] = getFIntUGCValidationHeadThreshold() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Right] = getFIntUGCValidationHeadThreshold() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Top] = getFIntUGCValidationHeadThreshold() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Bottom] = getFIntUGCValidationHeadThreshold() / 100
}

local ASSET_TRANSPARENCY_THRESHOLDS2 = ConstantsTransparencyValidation.ASSET_TRANSPARENCY_THRESHOLDS
local Torso = Enum.AssetType.Torso
ASSET_TRANSPARENCY_THRESHOLDS2[Torso] = {
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Front] = getFIntUGCValidationTorsoThresholdFront() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Back] = getFIntUGCValidationTorsoThresholdBack() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Left] = getFIntUGCValidationTorsoThresholdSide() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Right] = getFIntUGCValidationTorsoThresholdSide() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Top] = getFIntUGCValidationTorsoThresholdTopBottom() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Bottom] = getFIntUGCValidationTorsoThresholdTopBottom() / 100
}

local v = {
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Front] = getFIntUGCValidationArmThresholdFront() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Back] = getFIntUGCValidationArmThresholdBack() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Left] = getFIntUGCValidationArmThresholdSide() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Right] = getFIntUGCValidationArmThresholdSide() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Top] = getFIntUGCValidationArmThresholdTopBottom() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Bottom] = getFIntUGCValidationArmThresholdTopBottom() / 100
}

ConstantsTransparencyValidation.ASSET_TRANSPARENCY_THRESHOLDS[Enum.AssetType.LeftArm] = v
ConstantsTransparencyValidation.ASSET_TRANSPARENCY_THRESHOLDS[Enum.AssetType.RightArm] = v

local v2 = {
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Front] = getFIntUGCValidationLegThresholdFront() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Back] = getFIntUGCValidationLegThresholdBack() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Left] = getFIntUGCValidationLegThresholdSide() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Right] = getFIntUGCValidationLegThresholdSide() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Top] = getFIntUGCValidationLegThresholdTopBottom() / 100,
	[ConstantsTransparencyValidation.CAMERA_ANGLES.Bottom] = getFIntUGCValidationLegThresholdTopBottom() / 100
}

ConstantsTransparencyValidation.ASSET_TRANSPARENCY_THRESHOLDS[Enum.AssetType.LeftLeg] = v2
ConstantsTransparencyValidation.ASSET_TRANSPARENCY_THRESHOLDS[Enum.AssetType.RightLeg] = v2

ConstantsTransparencyValidation.ASSET_TRANSPARENCY_RASTER_SIZE = 100

return ConstantsTransparencyValidation
