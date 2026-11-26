local module = require("@luauforge/bundled/dtf")

local module2 = require("@luauforge/bundled/dtV")

return function(options, data)
	local v5 = options or {}

	if data.type ~= module2.name then
		return v5
	end

	v5 = module.Dictionary.join(v5, { [data.pageType] = data.refreshTime })

	return v5
end
