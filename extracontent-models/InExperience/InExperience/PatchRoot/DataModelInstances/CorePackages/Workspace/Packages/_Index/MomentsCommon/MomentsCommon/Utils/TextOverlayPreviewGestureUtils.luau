local TextOverlayPreviewGestureUtils = {}

function TextOverlayPreviewGestureUtils.getTouchLineAngleDegrees(list)
	if #list < 2 then
		return nil
	end

	local v = list[2] - list[1]
	return (math.deg((math.atan2(v.Y, v.X))))
end

function TextOverlayPreviewGestureUtils.getTouchRotationStepDegrees(p: number, p2: number)
	return (p2 - p + 90) % 180 - 90
end

function TextOverlayPreviewGestureUtils.touchGestureStartsOnOverlay(list, vector2: Vector2, vector2_2: Vector2): boolean
	if #list < 2 then
		return false
	end

	local midpoint = (list[1] + list[2]) / 2
	return midpoint.X >= vector2.X - 64
		and midpoint.X <= vector2.X + vector2_2.X + 64
		and midpoint.Y >= vector2.Y - 64
		and midpoint.Y <= vector2.Y + vector2_2.Y + 64
end

return TextOverlayPreviewGestureUtils
