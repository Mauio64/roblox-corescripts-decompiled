local module = require("@luauforge/bundled/hUc")

return function(p2, data)
	local v5 = p2 or { left = 0, top = 0, right = 0, bottom = 0 }

	assert(v5, "")

	if data.type == module.name then
		return {
			left = data.left,
			top = data.top,
			right = data.right,
			bottom = data.bottom
		}
	end

	return v5
end
