local TweenService = game:GetService("TweenService")

local function linearInterpolate(p: number, p2: number, value: number) -- 1 equivalent call inferred from this helper
	return p + (p2 - p) * value
end

local function getEasingNumberSequence(p: number, p2: number, p3: number, p4, p5)
	local numberSequenceKeypoints = {}

	for i = 0, p3 do
		local v = i / p3
		table.insert(
			numberSequenceKeypoints,
			(NumberSequenceKeypoint.new(v, linearInterpolate(p, p2, TweenService:GetValue(v, p4, p5)))) -- inferred equivalent call
		)
	end

	return numberSequenceKeypoints
end

return getEasingNumberSequence
