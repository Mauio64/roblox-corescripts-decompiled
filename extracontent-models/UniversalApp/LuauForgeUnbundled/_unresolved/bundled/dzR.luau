local module = require("@luauforge/bundled/dzS")
local module2 = require("@luauforge/bundled/dzU")

return {
	key = "ArtistSongsKey",
	reducer = function(options, p2)
		local joined = options or {}
		assert(joined, "")

		if p2 and p2.type == module.name then
			joined = module2.Dictionary.join(joined, p2.artistSongs)
		end

		return joined
	end
}
