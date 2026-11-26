local module = require("@luauforge/bundled/dDJ")

local module2 = require("@luauforge/bundled/dDK")

return {
	key = "ExperienceSongsKey",
	reducer = function(options, p2)
		local joined = options or {}
		assert(joined, "")

		if p2 and p2.type == module2.name then
			joined = module.Dictionary.join(joined, p2.experienceSongs)
		end

		return joined
	end
}
