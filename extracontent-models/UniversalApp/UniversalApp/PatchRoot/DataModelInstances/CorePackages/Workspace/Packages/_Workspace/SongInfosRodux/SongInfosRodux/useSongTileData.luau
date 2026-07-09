local SongInfosRodux = script:FindFirstAncestor("SongInfosRodux")
local SongInfosRoduxParent = SongInfosRodux.Parent

require(SongInfosRoduxParent.DiscoveryTypes)

local SongInfosReducer = require(SongInfosRodux.SongInfosReducer)
local useSelector = require(SongInfosRoduxParent.RoactUtils).Hooks.RoactRodux.useSelector
local useSongAlbumArt = require(SongInfosRoduxParent.Songbird).useSongAlbumArt
local tutils = require(SongInfosRoduxParent.tutils)

return function(s1: string?) -- line: 18
	-- upvalues: useSongAlbumArt (copy), useSelector (copy), SongInfosReducer (copy), tutils (copy)
	local v8 = useSongAlbumArt(s1)

	return {
		song = useSelector(function(p1) -- line: 21
			-- upvalues: SongInfosReducer (copy), s1 (copy)
			return p1.Personalization[SongInfosReducer.key][s1]
		end, tutils.shallowEqual),
		thumbnail = v8.value
	}
end
