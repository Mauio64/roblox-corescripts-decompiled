local SongDetailRodux = script:FindFirstAncestor("SongDetailRodux")
local SongDetailRoduxParent = SongDetailRodux.Parent
local React = require(SongDetailRoduxParent.React)
local RoactUtils = require(SongDetailRoduxParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local ApiFetchSongExperiences = require(SongDetailRodux.Thunks.ApiFetchSongExperiences)
local SongExperiencesReducer = require(SongDetailRodux.Reducers.SongExperiencesReducer)
local useRoactService = require(SongDetailRoduxParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(SongDetailRoduxParent.RoactServiceTags).RoactNetworking
local GameInfosReducer = require(SongDetailRoduxParent.GameInfosRodux).GameInfosReducer

require(SongDetailRoduxParent.DiscoveryTypes)
require(SongDetailRodux.Types)

return function(s1: string?) -- line: 31
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), ApiFetchSongExperiences (copy), SongExperiencesReducer (copy), GameInfosReducer (copy), React (copy)
	local v13 = useDispatch()
	local v14 = useRoactService(RoactNetworking)
	local v15 = useSelector(function(p1) -- line: 35
		-- upvalues: s1 (copy), ApiFetchSongExperiences (copy)
		return s1 and ApiFetchSongExperiences.GetFetchingStatus(p1, s1) or nil
	end)
	local v16 = useSelector(function(p2) -- line: 39
		-- upvalues: s1 (copy), SongExperiencesReducer (copy), GameInfosReducer (copy)
		if not s1 then
			return {}
		end

		local v20 = p2.Personalization[SongExperiencesReducer.key][s1]

		if not v20 then
			return {}
		end

		local t1 = {}

		for _, v23 in v20 do
			local v24 = p2.Personalization[GameInfosReducer.key][v23]

			if v24 then
				table.insert(t1, v24)
			end
		end

		return t1
	end)
	local v17 = React.useCallback(function() -- line: 58
		-- upvalues: s1 (copy), v13 (copy), ApiFetchSongExperiences (copy), v14 (copy)
		if s1 then
			v13(ApiFetchSongExperiences.Fetch(v14, s1))
		end
	end, {
		v13,
		v14,
		s1
	})

	React.useEffect(function() -- line: 64
		-- upvalues: v17 (copy)
		v17()
	end, { v17 })

	return {
		fetchStatus = v15,
		refetchSongExperiences = v17,
		songExperiences = v16
	}
end
