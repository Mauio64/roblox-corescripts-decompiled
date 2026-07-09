local SongDetailRodux = script:FindFirstAncestor("SongDetailRodux")
local SongDetailRoduxParent = SongDetailRodux.Parent
local React = require(SongDetailRoduxParent.React)
local RoactUtils = require(SongDetailRoduxParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

require(SongDetailRoduxParent.DiscoveryTypes)

local ApiFetchSongDetail = require(SongDetailRodux.Thunks.ApiFetchSongDetail)
local SongDetailReducer = require(SongDetailRodux.Reducers.SongDetailReducer)
local useRoactService = require(SongDetailRoduxParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(SongDetailRoduxParent.RoactServiceTags).RoactNetworking

require(SongDetailRodux.Types)

return function(s1: string?) -- line: 29
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), ApiFetchSongDetail (copy), SongDetailReducer (copy), React (copy)
	local v12 = useDispatch()
	local v13 = useRoactService(RoactNetworking)
	local v14 = useSelector(function(p1) -- line: 33
		-- upvalues: s1 (copy), ApiFetchSongDetail (copy)
		return s1 and ApiFetchSongDetail.GetFetchingStatus(p1, s1) or nil
	end)
	local v15 = useSelector(function(p2) -- line: 37
		-- upvalues: s1 (copy), SongDetailReducer (copy)
		return s1 and p2.Personalization[SongDetailReducer.key][s1] or nil
	end)
	local v16 = React.useCallback(function() -- line: 41
		-- upvalues: s1 (copy), v12 (copy), ApiFetchSongDetail (copy), v13 (copy)
		if s1 then
			v12(ApiFetchSongDetail.Fetch(v13, { s1 }))
		end
	end, {
		v12,
		v13,
		s1
	})

	React.useEffect(function() -- line: 47
		-- upvalues: v16 (copy)
		v16()
	end, { v16 })

	return {
		fetchStatus = v14,
		refetchSongDetail = v16,
		songDetail = v15,
		songId = s1
	}
end
