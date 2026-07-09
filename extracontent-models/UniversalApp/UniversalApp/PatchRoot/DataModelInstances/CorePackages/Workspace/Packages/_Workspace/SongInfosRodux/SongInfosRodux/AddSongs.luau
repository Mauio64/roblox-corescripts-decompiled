local Parent = script:FindFirstAncestor("SongInfosRodux").Parent
local makeActionCreator = require(Parent.Rodux).makeActionCreator

require(Parent.DiscoveryTypes)

local FFlagEnableTopSongsSort = require(Parent.SharedFlags).FFlagEnableTopSongsSort

return makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 11
	-- upvalues: FFlagEnableTopSongsSort (copy)
	assert(FFlagEnableTopSongsSort, "FFlagEnableTopSongsSort must be enabled to use AddSongs action")
	assert(type(t1) == "table", string.format("AddSongs action expects songs to be a table, was %s", (type(t1))))

	return {
		songs = t1
	}
end)
