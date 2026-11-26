local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")

local IXPService = game:GetService("IXPService")
local LocalizationService = game:GetService("LocalizationService")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/egs")
local module2 = require("@luauforge/bundled/gfe")
local module3 = require("@luauforge/bundled/dAB")
local networkProfiler = require("@game/CorePackages/Workspace/Packages/Http").NetworkProfiler

local module4 = require("@luauforge/bundled/gff")
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local module5 = require("@luauforge/bundled/gfg")
local httpCanceller = require("@game/CorePackages/Workspace/Packages/Http").NetworkLayers.HttpCanceller
local omniFeedConstants = require("@luauforge/bundled/cBc").OmniFeedConstants

local modules = require("@luauforge/bundled/dtb").Modules
local fetchHomePageData = modules.LuaApp.Thunks.FetchHomePageData
local fetchUserDataForHomePage = modules.LuaApp.Thunks.FetchUserDataForHomePage

local module6 = require("@luauforge/bundled/gfi")
local module7 = require("@luauforge/bundled/gfz")
local module8 = require("@luauforge/bundled/gfB")
local module9 = require("@luauforge/bundled/fCy")
local reportToDiagByCountryCode = require("@luauforge/bundled/bZt").ReportToDiagByCountryCode

local module10 = require("@luauforge/bundled/dFt")
local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEnableSduiHomePage

local fFlagSduiLaunchTemplatePrewarm = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSduiLaunchTemplatePrewarm
local fFlagAppIaHomeShowCampaignTab = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppIaHomeShowCampaignTab
local fFlagUseSignalsForPlatform = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForPlatform

local v5 = if fFlagUseSignalsForPlatform then require("@luauforge/bundled/fGm") else nil

local fFlagUseSignalsForStartup = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForStartup

local Signals = require(CorePackages.Packages.Signals)

local getStartupStore = if fFlagUseSignalsForStartup then require("@luauforge/bundled/gfE").GetStartupStore else nil

local v6 = {}

local function preloadChatData(p2)
	return {}
end

local function startStandardAppFirstClassPagePreloadOperations(data)
	local networkImpl = data.networkImpl
	local analytics = data.analytics
	local store = data.store
	local userId = data.userId
	local loggingProtocol = data.loggingProtocol
	local omniRecommendationsRequest = data.omniRecommendationsRequest
	local prefetchProtocol = data.prefetchProtocol

	local v7 = {}

	if fFlagLuaAppEnableSduiHomePage then
		if loggingProtocol then
			loggingProtocol:logEventOnce("preload_loading_home")
		end

		local module11 = require("@luauforge/bundled/fzZ")
		local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
		local loadTimer = require("@luauforge/bundled/dXB").SduiLoadTimer.createLoadTimer(appPage.Home)
		loadTimer.start("preload")

		local homePage = module11.fetchHomePage(loadTimer, {
			requestIntent = module11.HomeConstants.RequestIntent.LogIn
		})

		if homePage then
			table.insert(v7, homePage)
		end
	else
		local v8

		if fFlagUseSignalsForStartup then
			v8 = getStartupStore(false).getHomePageDataStatus(false)
		else
			v8 = store:getState().Startup.HomePageDataStatus
		end

		if v8 == module3.NotStarted then
			if loggingProtocol then
				loggingProtocol:logEventOnce("preload_loading_home")
			end

			table.insert(
				v7,
				(store:dispatch(fetchHomePageData(
					networkImpl,
					omniRecommendationsRequest,
					analytics,
					userId,
					data.policyData.getUseOmniRecommendation(),
					loggingProtocol,
					prefetchProtocol,
					omniFeedConstants.OmniRecommendationsRequestIntent.LogIn,
					nil,
					true
				)))
			)
		else
			local v9

			if fFlagUseSignalsForStartup then
				v9 = getStartupStore(false).getFetchHomePageDataStatusAll(false)
			else
				v9 = store:getState().Startup.FetchHomePageDataStatusAll
			end

			if v9 == module3.Fetching then
				if loggingProtocol then
					loggingProtocol:logEventOnce("preload_home_already_loading")
				end

				table.insert(v7, (module.new(function(callback, callback2)
					if fFlagUseSignalsForStartup then
						local v10 = nil
						local v11 = nil
						v11 = Signals.createEffect(function(p2)
							local fetchHomePageDataStatusAll = getStartupStore(false).getFetchHomePageDataStatusAll(p2)
							local v12 = v10
							v10 = fetchHomePageDataStatusAll

							if v12 == module3.Fetching and fetchHomePageDataStatusAll ~= v12 then
								if v11 ~= nil then
									v6[v11] = nil
									v11()
								end

								if fetchHomePageDataStatusAll == module3.Done then
									callback()
								else
									callback2()
								end
							end
						end)
						v6[v11] = true
					else
						local changedConnection = nil
						changedConnection = store.changed:connect(function(p2, p3)
							if
								p3.Startup.FetchHomePageDataStatusAll == module3.Fetching
								and p2.Startup.FetchHomePageDataStatusAll ~= p3.Startup.FetchHomePageDataStatusAll
							then
								if changedConnection ~= nil then
									changedConnection:disconnect()
									changedConnection = nil
								end

								if p2.Startup.FetchHomePageDataStatusAll == module3.Done then
									callback()
								else
									callback2()
								end
							end
						end)
					end
				end)))
			end
		end
	end

	return module2.Batch(v7):andThen(function(p2)
		if loggingProtocol then
			loggingProtocol:logEventOnce("preload_first_class_end")
		end

		local failureCount = module2.CountResults(p2).failureCount

		if failureCount ~= 0 then
			warn(string.format("%d of %d first-class preloading operations failed!", failureCount, #v7))

			if loggingProtocol then
				loggingProtocol:logEventOnce("preload_first_class_error")
			end
		end
	end)
end

local function startStandardAppSecondClassPagePreloadOperations(data)
	if data.loggingProtocol then
		data.loggingProtocol:logEventOnce("preload_second_class_begin")
	end

	local networkImpl = data.networkImpl
	local store = data.store
	local platform = data.platform

	local v7 = {}

	store:dispatch(fetchUserDataForHomePage(networkImpl, data.userId))

	table.insert(v7, store:dispatch(module6(networkImpl)))

	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local userId = data.userId
	table.insert(v7, (store:dispatch(module5(IXPService, userId)):andThen(function()
		local variationId = IXPService:GetUserLayerVariables(appUserLayers.SearchAutocompleteLayer).variationId
		return store:dispatch(module8.Fetch(networkImpl, 0, robloxLocaleId, variationId))
	end)))

	if module10.IsLuaGamesPagePreloadingEnabled(platform) then
		local module11 = require("@luauforge/bundled/gfF")

		local loadTimerWithSurfaceLoadTime = require("@luauforge/bundled/dXB").SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
			module11.ChartsConstants.ConfigKey,
			{
				eventName = module11.ChartsConstants.SurfaceLoadTimeEventName,
				metadata = { page = "preload" }
			}
		)

		loadTimerWithSurfaceLoadTime.start("preload")
		table.insert(v7, (module11.fetchChartsPage(loadTimerWithSurfaceLoadTime)))
	end

	if fFlagAppIaHomeShowCampaignTab then
		table.insert(v7, require("@luauforge/bundled/fJt").CampaignEligibility.fetchCampaignEligibility(networkImpl))
	end

	if fFlagSduiLaunchTemplatePrewarm then
		for k, v8 in require("@luauforge/bundled/dXB").prewarmAppTemplatesOnLaunch() do
			table.insert(v7, v8)
		end
	end

	local joined = Cryo.Dictionary.join(v7, {})

	local v8 = store:dispatch(module9(networkImpl, data.userId, true))
	table.insert(joined, v8)

	table.insert(joined, store:dispatch(module7(networkImpl)))

	return module2.Batch(joined):andThen(function(p2)
		local failureCount = module2.CountResults(p2).failureCount

		if failureCount ~= 0 then
			warn(string.format("%d of %d second-class preloading operations failed!", failureCount, #joined))
		end
	end)
end

return function(p2, p3, p4, p5, loggingProtocol, p6, prefetchProtocol)
	return function(object)
		if loggingProtocol then
			loggingProtocol:logEventOnce("preload_first_class_begin")
		end

		local currentSession = httpCanceller.currentSession()
		local v7 = {
			networkImpl = p2,
			analytics = p4,
			store = object,
			policyData = p5,
			platform = 0,
			userId = 0,
			loggingProtocol = 0,
			prefetchProtocol = 0
		}

		local v8 = if fFlagUseSignalsForPlatform then v5(false).getPlatform(false) else object:getState().Platform
		v7.platform = v8

		v7.userId = tostring(Players.LocalPlayer.UserId)
		v7.loggingProtocol = loggingProtocol
		v7.prefetchProtocol = prefetchProtocol

		return startStandardAppFirstClassPagePreloadOperations(v7):andThen(function()
			if not module4 then
				networkProfiler:report(reportToDiagByCountryCode)
			end

			if currentSession ~= httpCanceller.currentSession() then
				return
			end

			if not p6 or p6.isInteractive then
				return startStandardAppSecondClassPagePreloadOperations(v7)
			end

			return module.new(function(callback)
				local changedConnection = nil
				changedConnection = p6.changed:connect(function()
					if p6.isInteractive then
						if changedConnection ~= nil then
							changedConnection:disconnect()
							changedConnection = nil
						end

						if currentSession ~= httpCanceller.currentSession() then
							return
						end

						callback(startStandardAppSecondClassPagePreloadOperations(v7))
					end
				end)
			end)
		end)
	end
end
