game:DefineFastString("UGCValidationAccurateBoundingBoxTargetPercentage", "98.0")
game:DefineFastString("UGCValidationAccurateBoundingBoxPercentageWeight", "0.05")
game:DefineFastInt("UGCValidationAccurateBoundingBoxMaxIterations", 500)
game:DefineFastString("UGCValidationAccurateBoundingBoxConvergedLength", "0.001")
game:DefineFastString("UGCValidateAccurateBoundingBoxInflationThreshold", "0.334")
game:DefineFastFlag("UGCValidateAccurateBoundingBoxRasterMethod", false)
game:DefineFastFlag("UGCValidateAccurateBoundingBoxRasterMethodNeckAttachmentCrop", false)
game:DefineFastString("UGCValidateAccurateBoundingBoxRasterMethodNeckAttachmentCropMargin", "0.05")

local t1 = {
	targetPercentage = function() -- line: 51
		return (tonumber(game:GetFastString("UGCValidationAccurateBoundingBoxTargetPercentage")))
	end,
	percentageWeight = function() -- line: 55
		return (tonumber(game:GetFastString("UGCValidationAccurateBoundingBoxPercentageWeight")))
	end,
	maxIterations = function() -- line: 59
		return game:GetFastInt("UGCValidationAccurateBoundingBoxMaxIterations")
	end,
	convergedLength = function() -- line: 63
		return (tonumber(game:GetFastString("UGCValidationAccurateBoundingBoxConvergedLength")))
	end,
	inflationThreshold = function() -- line: 67
		return (tonumber(game:GetFastString("UGCValidateAccurateBoundingBoxInflationThreshold")))
	end,
	neckAttachmentCrop = function() -- line: 71
		return game:GetFastFlag("UGCValidateAccurateBoundingBoxRasterMethodNeckAttachmentCrop")
	end,
	neckAttachmentCropMargin = function() -- line: 75
		return (tonumber(game:GetFastString("UGCValidateAccurateBoundingBoxRasterMethodNeckAttachmentCropMargin")))
	end
}

game:DefineFastString("UGCValidationInflationThresholdDynamicHeadX", "0.334")
game:DefineFastString("UGCValidationInflationThresholdDynamicHeadY", "0.334")
game:DefineFastString("UGCValidationInflationThresholdDynamicHeadZ", "0.334")
game:DefineFastString("UGCValidationInflationThresholdTorsoX", "0.334")
game:DefineFastString("UGCValidationInflationThresholdTorsoY", "0.334")
game:DefineFastString("UGCValidationInflationThresholdTorsoZ", "0.334")
game:DefineFastString("UGCValidationInflationThresholdArmsX", "1.0")
game:DefineFastString("UGCValidationInflationThresholdArmsY", "0.334")
game:DefineFastString("UGCValidationInflationThresholdArmsZ", "1.0")
game:DefineFastString("UGCValidationInflationThresholdLegsX", "0.7")
game:DefineFastString("UGCValidationInflationThresholdLegsY", "0.334")
game:DefineFastString("UGCValidationInflationThresholdLegsZ", "0.7")

local t2 = {
	X = tonumber(game:GetFastString("UGCValidationInflationThresholdDynamicHeadX")),
	Y = tonumber(game:GetFastString("UGCValidationInflationThresholdDynamicHeadY")),
	Z = tonumber(game:GetFastString("UGCValidationInflationThresholdDynamicHeadZ"))
}
local t3 = {
	X = tonumber(game:GetFastString("UGCValidationInflationThresholdTorsoX")),
	Y = tonumber(game:GetFastString("UGCValidationInflationThresholdTorsoY")),
	Z = tonumber(game:GetFastString("UGCValidationInflationThresholdTorsoZ"))
}
local t4 = {
	X = tonumber(game:GetFastString("UGCValidationInflationThresholdArmsX")),
	Y = tonumber(game:GetFastString("UGCValidationInflationThresholdArmsY")),
	Z = tonumber(game:GetFastString("UGCValidationInflationThresholdArmsZ"))
}
local t5 = {
	X = tonumber(game:GetFastString("UGCValidationInflationThresholdLegsX")),
	Y = tonumber(game:GetFastString("UGCValidationInflationThresholdLegsY")),
	Z = tonumber(game:GetFastString("UGCValidationInflationThresholdLegsZ"))
}

t1.AssetTypeToAxisThresholds = {
	[Enum.AssetType.DynamicHead] = t2,
	[Enum.AssetType.Torso] = t3,
	[Enum.AssetType.LeftArm] = t4,
	[Enum.AssetType.RightArm] = t4,
	[Enum.AssetType.LeftLeg] = t5,
	[Enum.AssetType.RightLeg] = t5
}

return t1
