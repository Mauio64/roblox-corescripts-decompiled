local parent = script.Parent
local collect = require(parent.collect)

local function keyBy(p, callback)
	return collect(p, function(p2, p3)
		local v

		if typeof(callback) == "function" then
			v = callback(p3, p2)
		else
			v = p3[callback]
		end

		return v, p3
	end)
end

return keyBy
