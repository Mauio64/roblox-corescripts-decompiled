local Foundation = script:FindFirstAncestor("Foundation")

local FontScales = require(Foundation.Components.Text.FontScales)

return function(p: number, p2: number, p3: number)
	if p <= 0 or p2 <= 0 then
		return 0
	end

	local v = p3 <= 1 and 1 or p3

	local v2 = math.floor(p)

	local fontScale = FontScales[Font.fromEnum(Enum.Font.BuilderSans).Family]
	local v3 = fontScale == nil and 0 or (v2 / fontScale * (v * fontScale) - v2) / 2

	local v4 = math.ceil((p2 - 1) * v * v2)
	local v5

	if v3 >= 1 then
		v5 = math.ceil(v3)
	else
		v5 = math.floor(v3)
	end

	return v4 + v2 + v5
end
