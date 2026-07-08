local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)

local function GetSegmentIndexFromPosition(p1) -- line: 6
	-- upvalues: Constants (copy)
	local v5 = math.deg((math.atan2(p1.X, p1.Y)))

	if v5 < 0 then
		v5 += 360
	end

	local v6 = 360 / Constants.EmotesPerPage
	local v7 = math.ceil(math.ceil(math.fmod(v5 + math.ceil(v6 / 2), 360) / v6) + (Constants.SegmentsStartRotation + 90) / v6)

	if v7 > Constants.EmotesPerPage then
		return v7 - Constants.EmotesPerPage
	end

	if v7 < 1 then
		v7 += Constants.EmotesPerPage
	end

	return v7
end

return GetSegmentIndexFromPosition
