local module = require("@luauforge/bundled/dzz")

local module2 = require("@luauforge/bundled/dAB")
local module3 = require("@luauforge/bundled/dAC")
local module4 = require("@luauforge/bundled/dAD")

return function(options, data)
	local v5 = options or {}
	assert(v5, "")

	if data.type == module3.name then
		return (module.Set(v5, data.userId, data.status))
	end

	if data.type == module4.name then
		v5 = module.Set(v5, data.user.id, module2.Done)
	end

	return v5
end
