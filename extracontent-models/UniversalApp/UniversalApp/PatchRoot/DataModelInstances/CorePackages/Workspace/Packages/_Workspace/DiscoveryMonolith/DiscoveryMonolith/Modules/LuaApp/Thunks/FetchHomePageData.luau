local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local GameSortGroups = require(DiscoveryMonolithParent.DiscoveryTypes).GameSortGroups
local Promise = require(DiscoveryMonolithParent.Promise)
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local AppPage = require(DiscoveryMonolithParent.RobloxAppEnums).AppPage
local callOnce = require(DiscoveryMonolithParent.AppCommonLib).callOnce
local MemStorageKeys = require(DiscoveryMonolithParent.RobloxAppEnums).MemStorageKeys
local Modules = DiscoveryMonolith.Modules
local ApiFetchOmniRecommendations = require(Modules.LuaApp.Thunks.Omni.ApiFetchOmniRecommendations)
local ApiFetchGamesData = require(Modules.LuaApp.Thunks.Games.ApiFetchGamesData)
local ApiFetchSortTokens = require(Modules.LuaApp.Thunks.Games.ApiFetchSortTokens)
local SetHomePageDataStatus = require(Modules.LuaApp.Actions.SetHomePageDataStatus)
local SetFetchHomePageDataStatusAll = require(Modules.LuaApp.Actions.SetFetchHomePageDataStatusAll)
local FetchHomePageContactMethodModuleVariation = require(Modules.LuaApp.Thunks.FetchHomePageContactMethodModuleVariation)
local FetchUserDataForHomePage = require(Modules.LuaApp.Thunks.FetchUserDataForHomePage)
local GetIxpPerfRegressionTestSeconds = require(Modules.LuaApp.Flags.GetIxpPerfRegressionTestSeconds)
local GetFFlagEnableHomePageUpsellCard = require(Modules.LuaApp.Flags.GetFFlagEnableHomePageUpsellCard)
local FVariable = settings():GetFVariable("LuaAppsDiagPageLoadTimeHome")

local function fetchHomePageData(p1, p2, p3, p4, p5, p6, p7, p8, p9, _, p11) -- line: 25
	-- upvalues: RetrievalStatus (copy), Promise (copy), SetHomePageDataStatus (copy), SetFetchHomePageDataStatusAll (copy), GetFFlagEnableHomePageUpsellCard (copy), FetchHomePageContactMethodModuleVariation (copy), ApiFetchOmniRecommendations (copy), AppPage (copy), ApiFetchSortTokens (copy), GameSortGroups (copy), GetIxpPerfRegressionTestSeconds (copy), callOnce (copy), MemStorageKeys (copy), FetchUserDataForHomePage (copy), FVariable (copy), ApiFetchGamesData (copy)
	if p5:getState().Startup.HomePageDataStatus == RetrievalStatus.Fetching then
		return Promise.resolve("home page data is already fetching")
	end

	if p7 then
		p7:logEvent("fetch_homepage_data_begin")
	end

	local timestamp = tick()

	p5:dispatch(SetHomePageDataStatus(RetrievalStatus.Fetching))
	p5:dispatch(SetFetchHomePageDataStatusAll(RetrievalStatus.Fetching))

	if GetFFlagEnableHomePageUpsellCard() then
		p5:dispatch(FetchHomePageContactMethodModuleVariation(p1))
	end

	local v33 = p6 and function() -- line: 56
		-- upvalues: p8 (copy), p5 (copy), ApiFetchOmniRecommendations (copy), p1 (copy), p2 (copy), AppPage (copy), p9 (copy), p7 (copy)
		local v44 = nil

		if p8 then
			v44 = p8:popPendingPrefetchGuid()
		end

		return p5:dispatch(ApiFetchOmniRecommendations(p1, p2, AppPage.Home, nil, v44, p9, p7, true))
	end or function() -- line: 74
		-- upvalues: p5 (copy), ApiFetchSortTokens (copy), p1 (copy), GameSortGroups (copy)
		return p5:dispatch(ApiFetchSortTokens(p1, GameSortGroups.HomeGames, nil))
	end

	if not p11 then
		p5:dispatch(FetchUserDataForHomePage(p1, p4))
	end

	if p6 then
		return v33():andThen(function(_) -- line: 96
			-- upvalues: GetIxpPerfRegressionTestSeconds (copy), callOnce (copy), MemStorageKeys (copy), p5 (copy), SetHomePageDataStatus (copy), RetrievalStatus (copy), SetFetchHomePageDataStatusAll (copy), timestamp (copy), p3 (copy), FVariable (copy), p7 (copy)
			local v48, v49 = GetIxpPerfRegressionTestSeconds()

			if v48 then
				callOnce(MemStorageKeys.PerfRegressionTestTTI, function() -- line: 84
					-- upvalues: v49 (copy)
					if v49 ~= 0 then
						task.wait(v49)
					end
				end)
			end

			p5:dispatch(SetHomePageDataStatus(RetrievalStatus.Done))
			p5:dispatch(SetFetchHomePageDataStatusAll(RetrievalStatus.Done))

			local v50 = (tick() - timestamp) * 1000

			p3.Diag:reportStats(FVariable, v50)

			if p7 then
				p7:logEvent("fetch_homepage_data_end")
			end
		end, function(_) -- line: 106
			-- upvalues: p5 (copy), SetHomePageDataStatus (copy), RetrievalStatus (copy), SetFetchHomePageDataStatusAll (copy), p7 (copy)
			p5:dispatch(SetHomePageDataStatus(RetrievalStatus.Failed))
			p5:dispatch(SetFetchHomePageDataStatusAll(RetrievalStatus.Failed))

			if p7 then
				p7:logEvent("fetch_homepage_data_error")
			end
		end)
	end

	return v33():andThen(function(_) -- line: 115
		-- upvalues: p5 (copy), SetHomePageDataStatus (copy), RetrievalStatus (copy), ApiFetchGamesData (copy), p1 (copy), GameSortGroups (copy), Promise (copy)
		p5:dispatch(SetHomePageDataStatus(RetrievalStatus.Done))

		local t1 = { p5:dispatch(ApiFetchGamesData(p1, GameSortGroups.HomeGames)) }

		return Promise.all(t1)
	end, function(p15) -- line: 122
		-- upvalues: p5 (copy), SetHomePageDataStatus (copy), RetrievalStatus (copy), Promise (copy)
		p5:dispatch(SetHomePageDataStatus(RetrievalStatus.Failed))

		return Promise.reject(p15)
	end):andThen(function(_) -- line: 126
		-- upvalues: p5 (copy), RetrievalStatus (copy), SetFetchHomePageDataStatusAll (copy), timestamp (copy), p3 (copy), FVariable (copy), p7 (copy)
		local v56 = p5:getState().Startup.HomePageDataStatus == RetrievalStatus.Failed

		p5:dispatch(SetFetchHomePageDataStatusAll(v56 and RetrievalStatus.Failed or RetrievalStatus.Done))

		local v57 = (tick() - timestamp) * 1000

		p3.Diag:reportStats(FVariable, v57)

		if p7 then
			p7:logEvent("fetch_homepage_data_end")
		end
	end, function(_) -- line: 137
		-- upvalues: p5 (copy), SetFetchHomePageDataStatusAll (copy), RetrievalStatus (copy), p7 (copy)
		p5:dispatch(SetFetchHomePageDataStatusAll(RetrievalStatus.Failed))

		if p7 then
			p7:logEvent("fetch_homepage_data_error")
		end
	end)
end

return function(p18, p19, p20, p21, p22, p23, p24, p25, p26, p27) -- line: 146
	-- upvalues: fetchHomePageData (copy)
	return function(p28) -- line: 158
		-- upvalues: fetchHomePageData (copy), p18 (copy), p19 (copy), p20 (copy), p21 (copy), p22 (copy), p23 (copy), p24 (copy), p25 (copy), p26 (copy), p27 (copy)
		return fetchHomePageData(p18, p19, p20, p21, p28, p22, p23, p24, p25, p26, p27)
	end
end
