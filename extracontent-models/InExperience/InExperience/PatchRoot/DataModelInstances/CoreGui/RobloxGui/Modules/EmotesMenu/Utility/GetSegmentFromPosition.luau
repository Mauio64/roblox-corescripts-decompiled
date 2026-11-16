local parent = script.Parent.Parent

local Constants = require(parent.Constants)

local function GetSegmentIndexFromPosition(p)
	local v = math.deg((math.atan2(p.X, p.Y)))

	if v < 0 then
		v += 360
	end

	local v2 = 360 / Constants.EmotesPerPage
	local v3 = math.ceil(math.ceil(math.fmod(v + math.ceil(v2 / 2), 360) / v2) + (Constants.SegmentsStartRotation + 90) / v2)

	if Constants.EmotesPerPage < v3 then
		return v3 - Constants.EmotesPerPage
	end

	if v3 < 1 then
		return v3 + Constants.EmotesPerPage
	end

	return v3
end

return GetSegmentIndexFromPosition
