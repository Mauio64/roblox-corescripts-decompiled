local SongDetailRodux = script:FindFirstAncestor("SongDetailRodux")
local SongDetailRoduxParent = SongDetailRodux.Parent
local React = require(SongDetailRoduxParent.React)
local RoactUtils = require(SongDetailRoduxParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = require(SongDetailRoduxParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(SongDetailRoduxParent.RoactServiceTags).RoactNetworking
local ApiFetchArtistSongs = require(SongDetailRodux.Thunks.ApiFetchArtistSongs)
local ArtistSongReducer = require(SongDetailRodux.Reducers.ArtistSongReducer)

require(SongDetailRodux.Types)

return function(s1: string?) -- line: 25
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), ApiFetchArtistSongs (copy), ArtistSongReducer (copy), React (copy)
	local v12 = useDispatch()
	local v13 = useRoactService(RoactNetworking)
	local v14 = useSelector(function(p1) -- line: 29
		-- upvalues: s1 (copy), ApiFetchArtistSongs (copy)
		return s1 and ApiFetchArtistSongs.GetFetchingStatus(p1, s1) or nil
	end)
	local v15 = useSelector(function(p2) -- line: 33
		-- upvalues: s1 (copy), ArtistSongReducer (copy)
		return s1 and p2.Personalization[ArtistSongReducer.key][s1] or {}
	end)
	local v16 = React.useCallback(function() -- line: 37
		-- upvalues: s1 (copy), v12 (copy), ApiFetchArtistSongs (copy), v13 (copy)
		if s1 then
			v12(ApiFetchArtistSongs.Fetch(v13, s1))
		end
	end, {
		v12,
		v13,
		s1
	})

	React.useEffect(function() -- line: 43
		-- upvalues: v16 (copy)
		v16()
	end, { v16 })

	return {
		artistSongIds = v15,
		fetchStatus = v14,
		refetchArtistSongs = v16
	}
end
