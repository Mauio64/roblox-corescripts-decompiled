local TweenService = game:GetService("TweenService")

local function linearInterpolate(n1: number, n2: number, n3: number) -- line: 3
	return n1 + (n2 - n1) * n3
end
local function getEasingNumberSequence(n4: number, n5: number, n6: number, p1, p2) -- line: 7
	-- upvalues: TweenService (copy)
	local t1 = {}

	for i = 0, n6 do
		local v14 = i / n6
		local Value = TweenService:GetValue(v14, p1, p2)
		local v16 = n4 + (n5 - n4) * Value

		table.insert(t1, (NumberSequenceKeypoint.new(v14, v16)))
	end

	return t1
end

return getEasingNumberSequence
