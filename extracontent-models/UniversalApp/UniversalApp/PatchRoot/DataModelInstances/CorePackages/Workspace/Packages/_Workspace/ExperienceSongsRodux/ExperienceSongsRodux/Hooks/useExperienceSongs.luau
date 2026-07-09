local ExperienceSongsRodux = script:FindFirstAncestor("ExperienceSongsRodux")
local ExperienceSongsRoduxParent = ExperienceSongsRodux.Parent
local React = require(ExperienceSongsRoduxParent.React)
local RoactUtils = require(ExperienceSongsRoduxParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = require(ExperienceSongsRoduxParent.RobloxAppHooks).useRoactService
local RoactNetworking = require(ExperienceSongsRoduxParent.RoactServiceTags).RoactNetworking
local ApiFetchExperienceSongs = require(ExperienceSongsRodux.Thunks.ApiFetchExperienceSongs)
local ExperienceSongsReducer = require(ExperienceSongsRodux.Reducers.ExperienceSongsReducer)

return function(s1: string) -- line: 22
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), ExperienceSongsReducer (copy), React (copy), ApiFetchExperienceSongs (copy)
	local v12 = useDispatch()
	local v13 = useRoactService(RoactNetworking)
	local v14 = useSelector(function(p1) -- line: 26
		-- upvalues: ExperienceSongsReducer (copy), s1 (copy)
		return p1.Personalization[ExperienceSongsReducer.key] and p1.Personalization[ExperienceSongsReducer.key][s1] or {}
	end)

	React.useEffect(function() -- line: 32
		-- upvalues: v12 (copy), ApiFetchExperienceSongs (copy), v13 (copy), s1 (copy)
		v12(ApiFetchExperienceSongs.Fetch(v13, s1))
	end, {
		v12,
		v13,
		s1
	})

	return {
		songIds = v14
	}
end
