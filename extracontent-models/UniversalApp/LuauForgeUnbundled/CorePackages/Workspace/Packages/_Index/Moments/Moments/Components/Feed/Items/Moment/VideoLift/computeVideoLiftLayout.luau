local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/getCommentsVideoLift")

local TweenService = game:GetService("TweenService")

local getFitSize = MomentsCommon.Utils.getFitSize

local quad = Enum.EasingStyle.Quad

local function getDisplayedHeight(data)
	local resolution = data.resolution

	if data.scaleType == Enum.ScaleType.Fit and resolution ~= nil then
		return data.itemSize.Y * getFitSize(data.itemSize, resolution).Y.Scale
	end

	return data.itemSize.Y
end

local function computeVideoLiftLayout(data)
	local lift = data.lift
	local itemSize = data.itemSize

	if lift.progress <= 0 or itemSize.X <= 0 or itemSize.Y <= 0 then
		return nil
	end

	local v5 = lift.bandTop + data.padding
	local v6 = lift.bandBottom - data.padding - v5

	if v6 <= 0 then
		return nil
	end

	local resolution = data.resolution
	local v7

	if data.scaleType == Enum.ScaleType.Fit and resolution ~= nil then
		v7 = data.itemSize.Y * getFitSize(data.itemSize, resolution).Y.Scale
	else
		v7 = data.itemSize.Y
	end

	local v8 = math.min(v6 / v7, 1)
	local v9 = v5 + v6 / 2 - (data.itemTop + itemSize.Y / 2)
	local value = TweenService:GetValue(math.min(lift.progress, 1), quad, Enum.EasingDirection.In)
	return {
		scale = 1 + (v8 - 1) * value,
		offsetY = v9 * value,
		cornerRadius = not (v8 < 1) and 0 or data.cornerRadius * value
	}
end

return computeVideoLiftLayout
