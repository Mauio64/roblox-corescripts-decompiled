local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local t = require(DiscoveryMonolithParent.t)
local validateProps = require(DiscoveryMonolithParent.DiscoveryUtils).validateProps
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local RoactNetworking = require(DiscoveryMonolithParent.RoactServiceTags).RoactNetworking
local AppLogging = require(DiscoveryMonolithParent.RoactServiceTags).AppLogging
local FetchStatusRodux = require(DiscoveryMonolithParent.FetchStatusRodux)
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local NextDataExpirationTimeRodux = require(DiscoveryMonolithParent.NextDataExpirationTimeRodux)
local NextDataExpirationTimeReducer = NextDataExpirationTimeRodux.NextDataExpirationTimeReducer
local ExpirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace
local useRoactService = require(DiscoveryMonolithParent.RobloxAppHooks).useRoactService
local RoactUtils = require(DiscoveryMonolithParent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local OmniFeedConstants = require(DiscoveryMonolithParent.DiscoveryTypes).OmniFeedConstants
local Modules = DiscoveryMonolith.Modules
local ApiFetchSortTokens = require(Modules.LuaApp.Thunks.Games.ApiFetchSortTokens)
local ApiFetchOmniRecommendations = require(Modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendations)
local v23 = t.strictInterface({
	isOmni = t.boolean,
	pageType = t.string,
	sortToRefresh = t.string
})

local function OmniFeedAutoRefresher(t1: {[any]: any}) -- line: 42
	-- upvalues: validateProps (copy), v23 (copy), useRoactService (copy), RoactNetworking (copy), AppLogging (copy), React (copy), useSelector (copy), FetchStatusNamespace (copy), FetchStatusReducer (copy), NextDataExpirationTimeReducer (copy), ExpirationTimeNamespace (copy), useDispatch (copy), ApiFetchOmniRecommendations (copy), OmniFeedConstants (copy), ApiFetchSortTokens (copy), RetrievalStatus (copy)
	validateProps(v23, t1)

	local v26 = useRoactService(RoactNetworking)
	local v27 = useRoactService(AppLogging)
	local sortToRefresh = t1.sortToRefresh
	local v29 = React.useRef(nil)
	local v30 = React.useRef(nil)
	local v31 = useSelector(function(p1) -- line: 53
		-- upvalues: t1 (copy), FetchStatusNamespace (copy), sortToRefresh (copy), FetchStatusReducer (copy)
		local OmniRecommendations, pageType

		if t1.isOmni then
			OmniRecommendations = FetchStatusNamespace.OmniRecommendations
			pageType = t1.pageType
		else
			OmniRecommendations = FetchStatusNamespace.GameSortToken
			pageType = sortToRefresh
		end

		local v38 = p1.Personalization[FetchStatusReducer.key][OmniRecommendations]

		if v38 then
			return v38[pageType]
		end

		return nil
	end)
	local v32 = useSelector(function(p2) -- line: 72
		-- upvalues: t1 (copy), NextDataExpirationTimeReducer (copy), ExpirationTimeNamespace (copy)
		if t1.isOmni then
			local OmniRecommendationsRefreshTime = p2.OmniRecommendationsRefreshTime

			if OmniRecommendationsRefreshTime then
				return OmniRecommendationsRefreshTime[t1.pageType]
			end
		else
			local v41 = p2.Personalization[NextDataExpirationTimeReducer.key][ExpirationTimeNamespace.GameSortGroup]

			if v41 then
				return v41[t1.sortToRefresh]
			end
		end

		return nil
	end)
	local v33 = useDispatch()
	local v34 = React.useCallback(function() -- line: 91
		-- upvalues: v29 (copy), v32 (copy), t1 (copy), v33 (copy), ApiFetchOmniRecommendations (copy), v26 (copy), OmniFeedConstants (copy), v27 (copy), ApiFetchSortTokens (copy), sortToRefresh (copy)
		v29.current = v32

		if t1.isOmni then
			v33(ApiFetchOmniRecommendations(v26, nil, t1.pageType, nil, nil, OmniFeedConstants.OmniRecommendationsRequestIntent.AutoRefresh, v27))

			return
		end

		v33(ApiFetchSortTokens(v26, sortToRefresh, nil)):catch(function() -- line: 106
		end)
	end, {
		v32,
		t1.isOmni,
		v33,
		v26,
		nil,
		t1.pageType,
		v27,
		sortToRefresh
	})

	React.useEffect(function() -- line: 123
		-- upvalues: v31 (copy), RetrievalStatus (copy), v32 (copy), v29 (copy), v30 (copy), v34 (copy)
		if v31 ~= RetrievalStatus.Done then
			return
		end

		if not v32 or v32 <= 0 then
			return
		end

		if v29.current and v32 <= v29.current then
			return
		end

		local thread = task.defer(function(n1: number) -- line: 137
			-- upvalues: v30 (copy), v34 (copy)
			v30.current = true

			local v44 = n1 - tick()

			while v44 > 0 and v30.current do
				local v45 = math.min(v44, 300)

				task.wait(v45)
				v44 = n1 - tick()
			end

			if v30.current then
				v34()
				v30.current = nil
			end
		end, v32)

		return function() -- line: 155
			-- upvalues: thread (copy), v30 (copy)
			if thread and v30.current then
				task.cancel(thread)
				v30.current = nil
			end
		end
	end, {
		v31,
		v32,
		v34
	})

	return nil
end

return React.memo(OmniFeedAutoRefresher)
