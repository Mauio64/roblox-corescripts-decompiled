local deepEqual = require(script.Parent.deepEqual)
local deepContains = require(script.Parent.deepContains)

return function(p1, p2, p3) -- line: 4
	-- upvalues: deepContains (copy), deepEqual (copy)
	for _, v in ipairs(p1) do
		if not p3 then
			if not deepEqual(v, p2) then
				continue
			end

			return true
		end

		if deepContains(v, p2) then
			return true
		end
	end

	return false
end
