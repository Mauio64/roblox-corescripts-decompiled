local module = require("@luauforge/bundled/dww")

local module2 = require("@luauforge/bundled/dxy")
local module3 = require("@luauforge/bundled/dxz")
local module4 = require("@luauforge/bundled/dxA")

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
