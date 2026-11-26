local module = require("@luauforge/bundled/dvL")
local module2 = require("@luauforge/bundled/dvQ")
require("@luauforge/bundled/dvN")

return {
	key = "SongInfosKey",
	reducer = function(options, p2)
		local joined = options or {}
		assert(joined, "")

		if not p2 or p2.type ~= module.name then
			return joined
		end

		local v5 = {}

		for k, song in pairs(p2.songs) do
			if joined[k] then
				v5[k] = module2.Dictionary.join(joined[k], p2.songs[k])
			else
				v5[k] = p2.songs[k]
			end
		end

		joined = module2.Dictionary.join(joined, v5)

		return joined
	end
}
