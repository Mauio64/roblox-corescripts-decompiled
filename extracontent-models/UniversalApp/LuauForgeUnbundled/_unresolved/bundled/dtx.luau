local module = require("@luauforge/bundled/dqd")

local module2 = require("@luauforge/bundled/dqS")

return function(options, p2)
	local joined = options or {}

	if p2.type ~= module2.name then
		return joined
	end

	local values = {}

	for k, contentId in pairs(p2.contentIds) do
		local v5 = joined[k] or {}
		values[k] = module.Dictionary.join(v5, contentId)
	end

	joined = module.Dictionary.join(joined, values)

	return joined
end
