local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local MomentsCommon = require(parent.MomentsCommon)

require(Moments.Components.Comments.Sheet.getCommentsVideoLift)

local TweenService = game:GetService("TweenService")

local getFitSize = MomentsCommon.Utils.getFitSize

local Quad = Enum.EasingStyle.Quad

local function getDisplayedHeight(data) -- 1 equivalent call inferred from this helper
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

	local v = lift.bandTop + data.padding
	local v2 = lift.bandBottom - data.padding - v

	if v2 <= 0 then
		return nil
	end

	local v3 = math.min(v2 / getDisplayedHeight(data), 1) -- inferred equivalent call
	local v4 = v + v2 / 2 - (data.itemTop + itemSize.Y / 2)
	local value = TweenService:GetValue(math.min(lift.progress, 1), Quad, Enum.EasingDirection.In)
	return {
		scale = 1 + (v3 - 1) * value,
		offsetY = v4 * value,
		cornerRadius = not (v3 < 1) and 0 or data.cornerRadius * value
	}
end

return computeVideoLiftLayout
