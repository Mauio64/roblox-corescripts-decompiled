local parent = script.Parent
local reduce = require(parent.reduce)

local function fn(p, p2): boolean
	return p < p2
end

local function min(p, callback, callback2)
	local v = callback2 or fn

	if callback then
		return reduce(p, function(p2, original, p3)
			local v2 = callback(original, p3)

			if not p2 or v(v2, p2.value) then
				return { value = v2, original = original }
			end

			return p2
		end, nil).original
	end

	return reduce(p, function(p2, p3)
		return if not p2 or v(p3, p2) then p3 else p2
	end, nil)
end

return min
