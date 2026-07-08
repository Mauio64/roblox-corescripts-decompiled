local Foundation = script:FindFirstAncestor("Foundation")
local FontScales = require(Foundation.Components.Text.FontScales)

return function(n1: number, n2: number, n3: number) -- line: 5
	-- upvalues: FontScales (copy)
	if n1 <= 0 or n2 <= 0 then
		return 0
	end

	if n3 <= 1 then
		n3 = 1
	end

	local v6 = math.floor(n1)
	local n4 = 0
	local v8 = FontScales[Font.fromEnum(Enum.Font.BuilderSans).Family]

	if v8 ~= nil then
		n4 = (v6 / v8 * (n3 * v8) - v6) / 2
	end

	local v9 = math.ceil((n2 - 1) * n3 * v6)
	local v10 = if not (n4 >= 1) then math.floor(n4) else math.ceil(n4)

	return v9 + v6 + v10
end
