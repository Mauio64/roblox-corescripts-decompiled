local makeActionCreator = require("@luauforge/bundled/dsK").makeActionCreator
require("@luauforge/bundled/dsL")

local fFlagEnableTopSongsSort = require("@luauforge/bundled/dsM").FFlagEnableTopSongsSort

return makeActionCreator("AddSongs", function(p2)
	assert(fFlagEnableTopSongsSort, "FFlagEnableTopSongsSort must be enabled to use AddSongs action")
	assert(
		type(p2) == "table",
		string.format("AddSongs action expects songs to be a table, was %s", (type(p2)))
	)

	return { songs = p2 }
end)
