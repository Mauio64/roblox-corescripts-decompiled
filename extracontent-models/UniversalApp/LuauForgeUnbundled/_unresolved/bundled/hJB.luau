local module = require("@luauforge/bundled/hJC")

return function(p2, p3)
	local v5 = p2 or Enum.Platform.None
	assert(v5, "")

	if p3.type == module.name then
		return p3.platform
	end

	return v5
end
