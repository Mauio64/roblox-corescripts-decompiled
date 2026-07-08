local scriptParent = script.Parent
local getFIntUGCValidationHeadThreshold = require(scriptParent.flags.getFIntUGCValidationHeadThreshold)
local getFIntUGCValidationTorsoThresholdFront = require(scriptParent.flags.getFIntUGCValidationTorsoThresholdFront)
local getFIntUGCValidationTorsoThresholdBack = require(scriptParent.flags.getFIntUGCValidationTorsoThresholdBack)
local getFIntUGCValidationTorsoThresholdSide = require(scriptParent.flags.getFIntUGCValidationTorsoThresholdSide)
local getFIntUGCValidationTorsoThresholdTopBottom = require(scriptParent.flags.getFIntUGCValidationTorsoThresholdTopBottom)
local getFIntUGCValidationArmThresholdFront = require(scriptParent.flags.getFIntUGCValidationArmThresholdFront)
local getFIntUGCValidationArmThresholdBack = require(scriptParent.flags.getFIntUGCValidationArmThresholdBack)
local getFIntUGCValidationArmThresholdSide = require(scriptParent.flags.getFIntUGCValidationArmThresholdSide)
local getFIntUGCValidationArmThresholdTopBottom = require(scriptParent.flags.getFIntUGCValidationArmThresholdTopBottom)
local getFIntUGCValidationLegThresholdFront = require(scriptParent.flags.getFIntUGCValidationLegThresholdFront)
local getFIntUGCValidationLegThresholdBack = require(scriptParent.flags.getFIntUGCValidationLegThresholdBack)
local getFIntUGCValidationLegThresholdSide = require(scriptParent.flags.getFIntUGCValidationLegThresholdSide)
local getFIntUGCValidationLegThresholdTopBottom = require(scriptParent.flags.getFIntUGCValidationLegThresholdTopBottom)
local t1 = {
	CAMERA_ANGLES = {
		Front = "Front",
		Back = "Back",
		Left = "Left",
		Right = "Right",
		Top = "Top",
		Bottom = "Bottom"
	},
	ASSET_TRANSPARENCY_THRESHOLDS = {}
}

t1.ASSET_TRANSPARENCY_THRESHOLDS[Enum.AssetType.DynamicHead] = {
	[t1.CAMERA_ANGLES.Front] = getFIntUGCValidationHeadThreshold() / 100,
	[t1.CAMERA_ANGLES.Back] = getFIntUGCValidationHeadThreshold() / 100,
	[t1.CAMERA_ANGLES.Left] = getFIntUGCValidationHeadThreshold() / 100,
	[t1.CAMERA_ANGLES.Right] = getFIntUGCValidationHeadThreshold() / 100,
	[t1.CAMERA_ANGLES.Top] = getFIntUGCValidationHeadThreshold() / 100,
	[t1.CAMERA_ANGLES.Bottom] = getFIntUGCValidationHeadThreshold() / 100
}
t1.ASSET_TRANSPARENCY_THRESHOLDS[Enum.AssetType.Torso] = {
	[t1.CAMERA_ANGLES.Front] = getFIntUGCValidationTorsoThresholdFront() / 100,
	[t1.CAMERA_ANGLES.Back] = getFIntUGCValidationTorsoThresholdBack() / 100,
	[t1.CAMERA_ANGLES.Left] = getFIntUGCValidationTorsoThresholdSide() / 100,
	[t1.CAMERA_ANGLES.Right] = getFIntUGCValidationTorsoThresholdSide() / 100,
	[t1.CAMERA_ANGLES.Top] = getFIntUGCValidationTorsoThresholdTopBottom() / 100,
	[t1.CAMERA_ANGLES.Bottom] = getFIntUGCValidationTorsoThresholdTopBottom() / 100
}

local t2 = {
	[t1.CAMERA_ANGLES.Front] = getFIntUGCValidationArmThresholdFront() / 100,
	[t1.CAMERA_ANGLES.Back] = getFIntUGCValidationArmThresholdBack() / 100,
	[t1.CAMERA_ANGLES.Left] = getFIntUGCValidationArmThresholdSide() / 100,
	[t1.CAMERA_ANGLES.Right] = getFIntUGCValidationArmThresholdSide() / 100,
	[t1.CAMERA_ANGLES.Top] = getFIntUGCValidationArmThresholdTopBottom() / 100,
	[t1.CAMERA_ANGLES.Bottom] = getFIntUGCValidationArmThresholdTopBottom() / 100
}

t1.ASSET_TRANSPARENCY_THRESHOLDS[Enum.AssetType.LeftArm] = t2
t1.ASSET_TRANSPARENCY_THRESHOLDS[Enum.AssetType.RightArm] = t2

local t3 = {
	[t1.CAMERA_ANGLES.Front] = getFIntUGCValidationLegThresholdFront() / 100,
	[t1.CAMERA_ANGLES.Back] = getFIntUGCValidationLegThresholdBack() / 100,
	[t1.CAMERA_ANGLES.Left] = getFIntUGCValidationLegThresholdSide() / 100,
	[t1.CAMERA_ANGLES.Right] = getFIntUGCValidationLegThresholdSide() / 100,
	[t1.CAMERA_ANGLES.Top] = getFIntUGCValidationLegThresholdTopBottom() / 100,
	[t1.CAMERA_ANGLES.Bottom] = getFIntUGCValidationLegThresholdTopBottom() / 100
}

t1.ASSET_TRANSPARENCY_THRESHOLDS[Enum.AssetType.LeftLeg] = t3
t1.ASSET_TRANSPARENCY_THRESHOLDS[Enum.AssetType.RightLeg] = t3
t1.ASSET_TRANSPARENCY_RASTER_SIZE = 100

return t1
