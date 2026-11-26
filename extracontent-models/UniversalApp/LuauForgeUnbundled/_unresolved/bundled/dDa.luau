local module = require("@luauforge/bundled/dDb")
local module2 = require("@luauforge/bundled/dCZ")
require("@luauforge/bundled/dDc")

return {
	key = "SongDetailKey",
	reducer = function(options, p2)
		local joined = options or {}
		assert(joined, "")

		if not p2 or p2.type ~= module.name then
			return joined
		end

		local v5 = {}

		for k, v6 in pairs(p2.songDetail) do
			if joined[k] then
				v5[k] = module2.Dictionary.join(joined[k], p2.songDetail[k])
			else
				v5[k] = p2.songDetail[k]
			end
		end

		joined = module2.Dictionary.join(joined, v5)

		return joined
	end
}
