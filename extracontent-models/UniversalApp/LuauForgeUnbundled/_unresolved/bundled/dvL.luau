local makeActionCreator = require("@luauforge/bundled/dvM").makeActionCreator
require("@luauforge/bundled/dvN")

local fFlagEnableTopSongsSort = require("@luauforge/bundled/dvO").FFlagEnableTopSongsSort

return makeActionCreator("AddSongs", function(p2)
	assert(fFlagEnableTopSongsSort, "FFlagEnableTopSongsSort must be enabled to use AddSongs action")
	assert(
		type(p2) == "table",
		string.format("AddSongs action expects songs to be a table, was %s", (type(p2)))
	)

	return { songs = p2 }
end)
