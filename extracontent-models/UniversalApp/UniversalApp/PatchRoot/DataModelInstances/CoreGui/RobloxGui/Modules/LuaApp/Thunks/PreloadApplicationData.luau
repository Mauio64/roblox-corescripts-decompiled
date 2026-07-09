local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")
local Cryo = require(CorePackages.Packages.Cryo)
local Promise = require(Modules.LuaApp.Promise)
local PromiseUtilities = require(Modules.LuaApp.PromiseUtilities)
local RetrievalStatus = require(Modules.LuaApp.Enum.RetrievalStatus)
local NetworkProfiler = require(CorePackages.Workspace.Packages.Http).NetworkProfiler
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local WaitUntilIXPUserInit = require(Modules.LuaApp.Thunks.WaitUntilIXPUserInit)
local HttpCanceller = require(CorePackages.Workspace.Packages.Http).NetworkLayers.HttpCanceller
local OmniFeedConstants = require(CorePackages.Workspace.Packages.DiscoveryTypes).OmniFeedConstants
local Modules2 = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local FetchGamesPageData = Modules2.LuaApp.Thunks.FetchGamesPageData
local FetchHomePageData = Modules2.LuaApp.Thunks.FetchHomePageData
local FetchUserDataForHomePage = Modules2.LuaApp.Thunks.FetchUserDataForHomePage
local FetchNotificationCount = require(Modules.LuaApp.Thunks.FetchNotificationCount)
local ApiFetchSiteMessage = require(Modules.LuaApp.Thunks.ApiFetchSiteMessage)
local ApiFetchAutocompleteLocalCache = require(Modules.LuaApp.Thunks.ApiFetchAutocompleteLocalCache)
local ApiFetchEconomyCurrency = require(Modules.LuaApp.Thunks.ApiFetchEconomyCurrency)
local ReportToDiagByCountryCode = require(CorePackages.Workspace.Packages.Analytics).ReportToDiagByCountryCode
local usersFriendsPresenceOnAppStartup = require(Modules.LuaApp.Analytics.Events.usersFriendsPresenceOnAppStartup)
local FlagSettings = require(Modules.LuaApp.FlagSettings)
local FFlagLuaAppChartsResetFetchingStatusOnFilterChange = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppChartsResetFetchingStatusOnFilterChange
local FFlagLuaAppChartsAppPage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppChartsAppPage

local function preloadChatData(_) -- line: 36
	return {}
end
local function startStandardAppFirstClassPagePreloadOperations(p2) -- line: 42
	-- upvalues: RetrievalStatus (copy), FetchHomePageData (copy), OmniFeedConstants (copy), Promise (copy), PromiseUtilities (copy)
	local networkImpl = p2.networkImpl
	local analytics = p2.analytics
	local store = p2.store
	local userId = p2.userId
	local loggingProtocol = p2.loggingProtocol
	local omniRecommendationsRequest = p2.omniRecommendationsRequest
	local prefetchProtocol = p2.prefetchProtocol
	local t1 = {}

	if store:getState().Startup.HomePageDataStatus == RetrievalStatus.NotStarted then
		if loggingProtocol then
			loggingProtocol:logEventOnce("preload_loading_home")
		end

		table.insert(t1, (store:dispatch(FetchHomePageData(networkImpl, omniRecommendationsRequest, analytics, userId, p2.policyData.getUseOmniRecommendation(), loggingProtocol, prefetchProtocol, OmniFeedConstants.OmniRecommendationsRequestIntent.LogIn, nil, true))))
	elseif store:getState().Startup.FetchHomePageDataStatusAll == RetrievalStatus.Fetching then
		if loggingProtocol then
			loggingProtocol:logEventOnce("preload_home_already_loading")
		end

		local u41 = nil

		table.insert(t1, (Promise.new(function(resolve, reject) -- line: 80
			-- upvalues: u41 (ref), store (copy), RetrievalStatus (copy)
			u41 = store.changed:connect(function(p3, p4) -- line: 81
				-- upvalues: RetrievalStatus (copy), u41 (ref), resolve (copy), reject (copy)
				if p4.Startup.FetchHomePageDataStatusAll == RetrievalStatus.Fetching and p3.Startup.FetchHomePageDataStatusAll ~= p4.Startup.FetchHomePageDataStatusAll then
					if u41 ~= nil then
						u41:disconnect()
						u41 = nil
					end

					if p3.Startup.FetchHomePageDataStatusAll == RetrievalStatus.Done then
						resolve()

						return
					end

					reject()
				end
			end)
		end)))
	end

	return PromiseUtilities.Batch(t1):andThen(function(p5) -- line: 102
		-- upvalues: loggingProtocol (copy), PromiseUtilities (copy), t1 (copy)
		if loggingProtocol then
			loggingProtocol:logEventOnce("preload_first_class_end")
		end

		local failureCount = PromiseUtilities.CountResults(p5).failureCount

		if failureCount ~= 0 then
			warn(string.format("%d of %d first-class preloading operations failed!", failureCount, #t1))

			if loggingProtocol then
				loggingProtocol:logEventOnce("preload_first_class_error")
			end
		end
	end)
end
local function startStandardAppSecondClassPagePreloadOperations(p6) -- line: 117
	-- upvalues: FetchUserDataForHomePage (copy), FetchNotificationCount (copy), LocalizationService (copy), WaitUntilIXPUserInit (copy), IXPService (copy), AppUserLayers (copy), ApiFetchAutocompleteLocalCache (copy), FFlagLuaAppChartsAppPage (copy), FlagSettings (copy), CorePackages (copy), FFlagLuaAppChartsResetFetchingStatusOnFilterChange (copy), RetrievalStatus (copy), FetchGamesPageData (copy), Cryo (copy), ApiFetchEconomyCurrency (copy), ApiFetchSiteMessage (copy), PromiseUtilities (copy)
	if p6.loggingProtocol then
		p6.loggingProtocol:logEventOnce("preload_second_class_begin")
	end

	local networkImpl = p6.networkImpl
	local analytics = p6.analytics
	local store = p6.store
	local platform = p6.platform
	local t2 = {}

	store:dispatch(FetchUserDataForHomePage(networkImpl, p6.userId))
	table.insert(t2, store:dispatch(FetchNotificationCount(networkImpl)))

	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local userId = p6.userId

	table.insert(t2, (store:dispatch(WaitUntilIXPUserInit(IXPService, userId)):andThen(function() -- line: 137
		-- upvalues: IXPService (copy), AppUserLayers (copy), store (copy), ApiFetchAutocompleteLocalCache (copy), networkImpl (copy), RobloxLocaleId (copy)
		local variationId = IXPService:GetUserLayerVariables(AppUserLayers.SearchAutocompleteLayer).variationId

		return store:dispatch(ApiFetchAutocompleteLocalCache.Fetch(networkImpl, 0, RobloxLocaleId, variationId))
	end)))

	if FFlagLuaAppChartsAppPage then
		if FlagSettings.IsLuaGamesPagePreloadingEnabled(platform) then
			local Charts = require(CorePackages.Workspace.Packages.Charts)
			local v51 = require(CorePackages.Workspace.Packages.SduiSharedUtilities).SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(Charts.ChartsConstants.ConfigKey, {
				eventName = Charts.ChartsConstants.SurfaceLoadTimeEventName,
				metadata = {
					page = "preload"
				}
			})

			v51.start("preload")
			table.insert(t2, (Charts.fetchChartsPage(v51)))
		end
	elseif FlagSettings.IsLuaGamesPagePreloadingEnabled(platform) and ((if not FFlagLuaAppChartsResetFetchingStatusOnFilterChange then store:getState().Startup.GamesPageDataStatus else store:getState().Startup.GamesPageDataStatus.status)) == RetrievalStatus.NotStarted then
		table.insert(t2, (store:dispatch(FetchGamesPageData(networkImpl, analytics, nil))))
	end

	local u52 = Cryo.Dictionary.join(t2, {})

	table.insert(u52, (store:dispatch(ApiFetchEconomyCurrency(networkImpl, p6.userId, true))))
	table.insert(u52, store:dispatch(ApiFetchSiteMessage(networkImpl)))

	return PromiseUtilities.Batch(u52):andThen(function(p7) -- line: 185
		-- upvalues: PromiseUtilities (copy), u52 (ref)
		local failureCount = PromiseUtilities.CountResults(p7).failureCount

		if failureCount ~= 0 then
			warn(string.format("%d of %d second-class preloading operations failed!", failureCount, #u52))
		end
	end)
end

return function(p8, _, p10, p11, p12, p13, p14) -- line: 194
	-- upvalues: HttpCanceller (copy), Players (copy), startStandardAppFirstClassPagePreloadOperations (copy), NetworkProfiler (copy), ReportToDiagByCountryCode (copy), usersFriendsPresenceOnAppStartup (copy), startStandardAppSecondClassPagePreloadOperations (copy), Promise (copy)
	return function(p15) -- line: 203
		-- upvalues: p12 (copy), HttpCanceller (copy), p8 (copy), p10 (copy), p11 (copy), Players (copy), p14 (copy), startStandardAppFirstClassPagePreloadOperations (copy), NetworkProfiler (copy), ReportToDiagByCountryCode (copy), usersFriendsPresenceOnAppStartup (copy), p13 (copy), startStandardAppSecondClassPagePreloadOperations (copy), Promise (copy)
		if p12 then
			p12:logEventOnce("preload_first_class_begin")
		end

		local v68 = HttpCanceller.currentSession()
		local t3 = {
			networkImpl = p8,
			analytics = p10,
			store = p15,
			policyData = p11,
			platform = p15:getState().Platform,
			userId = tostring(Players.LocalPlayer.UserId),
			loggingProtocol = p12,
			prefetchProtocol = p14
		}

		return startStandardAppFirstClassPagePreloadOperations(t3):andThen(function() -- line: 219
			-- upvalues: NetworkProfiler (copy), ReportToDiagByCountryCode (copy), usersFriendsPresenceOnAppStartup (copy), p15 (copy), p10 (copy), v68 (copy), HttpCanceller (copy), p13 (copy), startStandardAppSecondClassPagePreloadOperations (copy), t3 (copy), Promise (copy)
			NetworkProfiler:report(ReportToDiagByCountryCode)
			usersFriendsPresenceOnAppStartup(p15:getState(), p10)

			if v68 ~= HttpCanceller.currentSession() then
				return
			end

			if not p13 or p13.isInteractive then
				return startStandardAppSecondClassPagePreloadOperations(t3)
			end

			return Promise.new(function(resolve) -- line: 235
				-- upvalues: p13 (copy), v68 (copy), HttpCanceller (copy), startStandardAppSecondClassPagePreloadOperations (copy), t3 (copy)
				local u73 = nil

				u73 = p13.changed:connect(function() -- line: 237
					-- upvalues: p13 (copy), u73 (ref), v68 (copy), HttpCanceller (copy), resolve (copy), startStandardAppSecondClassPagePreloadOperations (copy), t3 (copy)
					if p13.isInteractive then
						if u73 ~= nil then
							u73:disconnect()
							u73 = nil
						end

						if v68 ~= HttpCanceller.currentSession() then
							return
						end

						resolve(startStandardAppSecondClassPagePreloadOperations(t3))
					end
				end)
			end)
		end)
	end
end
