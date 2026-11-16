local module = require("@luauforge/bundled/dqd")

local module2 = require("@luauforge/bundled/dqT")

return function(options, data)
	local v5 = options or {}

	if data.type ~= module2.name then
		return v5
	end

	v5 = module.Dictionary.join(v5, { [data.pageType] = data.refreshTime })

	return v5
end
