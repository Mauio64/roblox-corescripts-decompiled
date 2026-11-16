local immutable = require("@luauforge/bundled/dqY").Immutable

local module = require("@luauforge/bundled/dqU")

return function(options, data)
	local v5 = options or {}
	assert(v5, "")

	if data.type == module.name then
		v5 = immutable.Set(v5, data.universeId, data.entries)
	end

	return v5
end
