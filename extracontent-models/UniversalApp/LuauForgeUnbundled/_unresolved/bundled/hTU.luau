local module = require("@luauforge/bundled/dzz")

local module2 = require("@luauforge/bundled/fwS")

return function(options, data)
	local v5 = options or {}
	assert(v5, "")

	if data.type == module2.name then
		v5 = module.Set(v5, data.searchUuid, data.parameters)
	end

	return v5
end
