local parent = script.Parent
require(parent.Types)
local reduce = require(parent.reduce)

local function frequencies(p, callback)
	return reduce(p, function(p2, p3, p4)
		if callback then
			p3 = callback(p3, p4)
		end

		if p2[p3] == nil then
			p2[p3] = 1
			return p2
		end

		p2[p3] += 1

		return p2
	end, {})
end

return frequencies
