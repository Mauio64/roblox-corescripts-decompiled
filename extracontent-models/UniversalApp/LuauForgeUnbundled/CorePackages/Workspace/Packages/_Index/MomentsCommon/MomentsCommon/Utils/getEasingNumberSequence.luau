local TweenService = game:GetService("TweenService")

local function linearInterpolate(p2, p3, p4)
	return p2 + (p3 - p2) * p4
end

local function getEasingNumberSequence(p2, p3, p4, p5, p6)
	local numberSequenceKeypoints = {}

	for i = 0, p4 do
		local v5 = i / p4
		local value = TweenService:GetValue(v5, p5, p6)
		local v6 = p2 + (p3 - p2) * value

		table.insert(numberSequenceKeypoints, (NumberSequenceKeypoint.new(v5, v6)))
	end

	return numberSequenceKeypoints
end

return getEasingNumberSequence
