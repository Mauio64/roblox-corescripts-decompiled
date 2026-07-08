local scriptParent = script.Parent
local reduce = require(scriptParent.reduce)

local function v3(p1, p2) -- line: 8
	return p2 < p1
end
local function max(t1: {[any]: any}, p3: ((...any) -> ...any)?, p4: ((...any) -> ...any)?) -- line: 46
	-- upvalues: v3 (copy), reduce (copy)
	local v10 = p4 or v3

	if p3 then
		return reduce(t1, function(p5, p6, p7) -- line: 50
			-- upvalues: p3 (copy), v10 (copy)
			local v14 = p3(p6, p7)

			if not p5 then
				return {
					value = v14,
					original = p6
				}
			end

			if v10(v14, p5.value) then
				return {
					value = v14,
					original = p6
				}
			end

			return p5
		end, nil).original
	end

	return reduce(t1, function(p8, p9) -- line: 60
		-- upvalues: v10 (copy)
		if not p8 then
			return p9
		end

		if v10(p9, p8) then
			return p9
		end

		return p8
	end, nil)
end

return max
