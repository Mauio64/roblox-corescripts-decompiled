game:DefineFastString("UGCValidationAccurateBoundingBoxTargetPercentage", "98.0")

game:DefineFastString("UGCValidationAccurateBoundingBoxPercentageWeight", "0.05")

game:DefineFastInt("UGCValidationAccurateBoundingBoxMaxIterations", 500)

game:DefineFastString("UGCValidationAccurateBoundingBoxConvergedLength", "0.001")

game:DefineFastString("UGCValidateAccurateBoundingBoxInflationThreshold", "0.334")

game:DefineFastFlag("UGCValidateAccurateBoundingBoxRasterMethod", false)

game:DefineFastFlag("UGCValidateAccurateBoundingBoxRasterMethodNeckAttachmentCrop", false)

game:DefineFastString("UGCValidateAccurateBoundingBoxRasterMethodNeckAttachmentCropMargin", "0.05")

local ValidateAccurateBoundingBoxFlags = {
	targetPercentage = function()
		return (tonumber(game:GetFastString("UGCValidationAccurateBoundingBoxTargetPercentage")))
	end,
	percentageWeight = function()
		return (tonumber(game:GetFastString("UGCValidationAccurateBoundingBoxPercentageWeight")))
	end,
	maxIterations = function()
		return game:GetFastInt("UGCValidationAccurateBoundingBoxMaxIterations")
	end,
	convergedLength = function()
		return (tonumber(game:GetFastString("UGCValidationAccurateBoundingBoxConvergedLength")))
	end,
	inflationThreshold = function()
		return (tonumber(game:GetFastString("UGCValidateAccurateBoundingBoxInflationThreshold")))
	end,
	neckAttachmentCrop = function()
		return game:GetFastFlag("UGCValidateAccurateBoundingBoxRasterMethodNeckAttachmentCrop")
	end,
	neckAttachmentCropMargin = function()
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

local v = {
	X = tonumber(game:GetFastString("UGCValidationInflationThresholdDynamicHeadX")),
	Y = tonumber(game:GetFastString("UGCValidationInflationThresholdDynamicHeadY")),
	Z = tonumber(game:GetFastString("UGCValidationInflationThresholdDynamicHeadZ"))
}

local v2 = {
	X = tonumber(game:GetFastString("UGCValidationInflationThresholdTorsoX")),
	Y = tonumber(game:GetFastString("UGCValidationInflationThresholdTorsoY")),
	Z = tonumber(game:GetFastString("UGCValidationInflationThresholdTorsoZ"))
}

local v3 = {
	X = tonumber(game:GetFastString("UGCValidationInflationThresholdArmsX")),
	Y = tonumber(game:GetFastString("UGCValidationInflationThresholdArmsY")),
	Z = tonumber(game:GetFastString("UGCValidationInflationThresholdArmsZ"))
}

local v4 = {
	X = tonumber(game:GetFastString("UGCValidationInflationThresholdLegsX")),
	Y = tonumber(game:GetFastString("UGCValidationInflationThresholdLegsY")),
	Z = tonumber(game:GetFastString("UGCValidationInflationThresholdLegsZ"))
}

ValidateAccurateBoundingBoxFlags.AssetTypeToAxisThresholds = {
	[Enum.AssetType.DynamicHead] = v,
	[Enum.AssetType.Torso] = v2,
	[Enum.AssetType.LeftArm] = v3,
	[Enum.AssetType.RightArm] = v3,
	[Enum.AssetType.LeftLeg] = v4,
	[Enum.AssetType.RightLeg] = v4
}

return ValidateAccurateBoundingBoxFlags
