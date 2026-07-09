local SongDetailRodux = script:FindFirstAncestor("SongDetailRodux")
local SongDetailRoduxParent = SongDetailRodux.Parent
local AddArtistSongs = require(SongDetailRodux.Actions.AddArtistSongs)
local Cryo = require(SongDetailRoduxParent.Cryo)

return {
	key = "ArtistSongsKey",
	reducer = function(t1: {[any]: any}?, p1) -- line: 11
		-- upvalues: AddArtistSongs (copy), Cryo (copy)
		local v7 = t1 or {}

		assert(v7, "")

		if p1 and p1.type == AddArtistSongs.name then
			v7 = Cryo.Dictionary.join(v7, p1.artistSongs)
		end

		return v7
	end
}
