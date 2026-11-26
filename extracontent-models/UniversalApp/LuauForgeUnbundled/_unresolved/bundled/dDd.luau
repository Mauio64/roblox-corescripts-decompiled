local module = require("@luauforge/bundled/dDe")
local module2 = require("@luauforge/bundled/dCZ")

return {
	key = "SongExperiencesKey",
	reducer = function(options, p2)
		local joined = options or {}
		assert(joined, "")

		if p2 and p2.type == module.name then
			joined = module2.Dictionary.join(joined, p2.songExperiences)
		end

		return joined
	end
}
