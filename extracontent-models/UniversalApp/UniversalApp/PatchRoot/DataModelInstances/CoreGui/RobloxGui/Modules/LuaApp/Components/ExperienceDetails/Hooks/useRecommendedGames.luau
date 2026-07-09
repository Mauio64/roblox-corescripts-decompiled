local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local RecommendedGames = require(Modules.LuaApp.Thunks.Games.RecommendedGames)
local ApiFetchExperienceDetailsPage = require(Modules.LuaApp.Thunks.Games.ApiFetchExperienceDetailsPage)
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local t1 = {}

return function(s1: string, b1: boolean?) -- line: 26
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useSelector (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ApiFetchExperienceDetailsPage (copy), RecommendedGames (copy), t1 (copy), React (copy)
	local v16 = useDispatch()
	local v17 = useRoactService(RoactNetworking)
	local v18 = useSelector(function(p1) -- line: 30
		-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy), s1 (copy), ApiFetchExperienceDetailsPage (copy), RecommendedGames (copy)
		if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and b1 then
			return s1 and ApiFetchExperienceDetailsPage.GetFetchingStatus(p1, s1) or nil
		end

		return s1 and RecommendedGames.GetFetchingStatus(p1, s1) or nil
	end)
	local v19 = useSelector(function(p2) -- line: 41
		-- upvalues: s1 (copy), t1 (copy)
		local v23 = p2.RecommendedGameEntries and p2.RecommendedGameEntries[s1] or nil

		if not v23 then
			return t1
		end

		return v23
	end)
	local v20 = React.useCallback(function() -- line: 50
		-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy), v16 (copy), RecommendedGames (copy), v17 (copy), s1 (copy)
		if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and b1 then
			return
		end

		v16(RecommendedGames.Fetch(v17, s1, {
			maxRows = 6
		}))
	end, {
		v16,
		v17,
		s1,
		b1
	})

	React.useEffect(function() -- line: 71
		-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), b1 (copy), v20 (copy)
		if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and b1 then
			return
		end

		v20()
	end, {
		v20,
		b1
	})

	return {
		fetchStatus = v18,
		refetchRecommendedGames = v20,
		recommendedGames = v19
	}
end
