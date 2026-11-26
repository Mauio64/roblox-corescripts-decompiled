local resolveMaxCropFraction = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/resolveMaxCropFraction")

local FFlagMomentsSmartVideoFillLandscape = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsSmartVideoFillLandscape")
local FIntMomentsMaxVideoCropPercent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FIntMomentsMaxVideoCropPercent")

local function getSmartFillScaleType(p2, p3, p4, p5)
	if p2 ~= Enum.ScaleType.Fit or p4 == nil or p4.X == 0 or p4.Y == 0 then
		return p2
	end

	local v5 = resolveMaxCropFraction(p3, p4, p5 or math.clamp(FIntMomentsMaxVideoCropPercent, 0, 100) / 100, FFlagMomentsSmartVideoFillLandscape)

	if v5 <= 0 then
		return p2
	end

	if v5 >= 1 then
		return Enum.ScaleType.Crop
	end

	local v6 = p3.X / p3.Y
	local v7 = p4.X / p4.Y

	if math.max(v6 / v7, v7 / v6) <= 1 / (1 - v5) then
		return Enum.ScaleType.Crop
	end

	return p2
end

return getSmartFillScaleType
