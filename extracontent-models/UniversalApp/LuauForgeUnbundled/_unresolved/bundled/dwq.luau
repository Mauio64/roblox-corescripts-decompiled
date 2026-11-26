local module = require("@luauforge/bundled/dtf")

local module2 = require("@luauforge/bundled/dtQ")

return function(options, data)
	local joined = options or {}

	if data.type ~= module2.name then
		return joined
	end

	if data.isAppend then
		for k, recommendation in pairs(data.recommendations) do
			local v5 = joined[k]

			if not v5 then
				continue
			end

			local joined2 = module.List.join(v5.sorts, recommendation.sorts)
			local joined3 = module.Dictionary.join(v5, recommendation)
			joined3.sorts = joined2

			joined3.metadata = nil

			joined = module.Dictionary.join(joined, { [k] = joined3 })
		end

		return joined
	else
		local clone = table.clone(data.recommendations)

		for k, v5 in clone do
			clone[k] = module.Dictionary.join(v5, { metadata = module.None })
		end

		joined = module.Dictionary.join(joined, clone)

		return joined
	end
end
