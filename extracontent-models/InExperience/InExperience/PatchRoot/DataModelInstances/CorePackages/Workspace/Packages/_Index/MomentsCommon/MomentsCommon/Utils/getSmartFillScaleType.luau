local MomentsCommon = script:FindFirstAncestor("MomentsCommon")

local resolveMaxCropFraction = require(MomentsCommon.Utils.resolveMaxCropFraction)

local FFlagMomentsSmartVideoFillLandscape = require(MomentsCommon.Flags.FFlagMomentsSmartVideoFillLandscape)
local FIntMomentsMaxVideoCropPercent = require(MomentsCommon.Flags.FIntMomentsMaxVideoCropPercent)

local function getSmartFillScaleType(p, vector2: Vector2, vector2_2: Vector2?, p2: number?)
	if p ~= Enum.ScaleType.Fit or vector2_2 == nil or vector2_2.X == 0 or vector2_2.Y == 0 then
		return p
	end

	local maxCropFraction = resolveMaxCropFraction(
		vector2,
		vector2_2,
		p2 or math.clamp(FIntMomentsMaxVideoCropPercent, 0, 100) / 100,
		FFlagMomentsSmartVideoFillLandscape
	)

	if maxCropFraction <= 0 then
		return p
	end

	if maxCropFraction >= 1 then
		return Enum.ScaleType.Crop
	end

	local v = vector2.X / vector2.Y
	local v2 = vector2_2.X / vector2_2.Y

	if math.max(v / v2, v2 / v) <= 1 / (1 - maxCropFraction) then
		return Enum.ScaleType.Crop
	end

	return p
end

return getSmartFillScaleType
