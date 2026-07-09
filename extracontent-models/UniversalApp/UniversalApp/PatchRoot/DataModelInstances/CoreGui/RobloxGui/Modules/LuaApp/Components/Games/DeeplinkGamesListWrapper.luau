local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local GameSortGroups = require(CorePackages.Workspace.Packages.DiscoveryTypes).GameSortGroups
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local NavigateBack = require(CorePackages.Workspace.Packages.NavigationRodux).Thunks.NavigateBack
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local TopicContentsReducer = require(CorePackages.Workspace.Packages.TopicContentsRodux).TopicContentsReducer
local RefreshExpiringSortTokens = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Thunks.Games.RefreshExpiringSortTokens
local FetchStatusRodux = require(CorePackages.Workspace.Packages.FetchStatusRodux)
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local RetrievalStatus = require(CorePackages.Workspace.Packages.Http).Enum.RetrievalStatus
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local UIBlox = require(CorePackages.Packages.UIBlox)
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GamesList = require(Modules.LuaApp.Components.Games.GamesList)
local SduiChartsSortDetailPage = require(Modules.Personalization.Games.SduiChartsSortDetailPage)
local getChartsSortDetailPageKey = require(CorePackages.Workspace.Packages.Charts).getChartsSortDetailPageKey
local SduiSharedUtilities = require(CorePackages.Workspace.Packages.SduiSharedUtilities)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local useUiStatus = SduiSharedUtilities.useUiStatus
local UiStatus = SduiSharedUtilities.UiStatus
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local sortDeeplinkFailureCounter = require(CorePackages.Workspace.Packages.DiscoveryAnalytics).Events.sortDeeplinkFailureCounter
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigationProps = require(CorePackages.Workspace.Packages.RobloxAppNavigation).useNavigationProps
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local FFlagLuaAppChartsAppPage = SharedFlags.FFlagLuaAppChartsAppPage
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local v35 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local v36 = game:DefineFastFlag("LuaAppDeeplinkGamesListWrapperFixBackgroundColor", false)
local v37 = game:DefineFastInt("LuaAppSortDeeplinkFetchingTimeoutInSec", 10)
local _ = {
	InvalidSort = "InvalidSort",
	SortTokenFetchFailed = "SortTokenFetchFailed",
	SortTokenFetchTimeout = "SortTokenFetchTimeout"
}

local function getSortIndex(p1, p2) -- line: 70
	if not p2 then
		return nil
	end

	for v44, v45 in p2 do
		if p1 == tostring(v45.topicId) then
			return v44
		end
	end

	return nil
end
local function DeeplinkGamesListWrapper() -- line: 85
	-- upvalues: useNavigationProps (copy), useDispatch (copy), useRoactService (copy), RoactNetworking (copy), useTokens (copy), useSelector (copy), TopicContentsReducer (copy), AppPage (copy), FetchStatusNamespace (copy), GameSortGroups (copy), FetchStatusReducer (copy), RetrievalStatus (copy), React (copy), RefreshExpiringSortTokens (copy), LoggingProtocol (copy), sortDeeplinkFailureCounter (copy), FFlagSignalsNavP3Dispatch (copy), v35 (copy), NavigateBack (copy), v37 (copy), LoadingStateContainer (copy), RetrievalStatus2 (copy), GamesList (copy), v36 (copy)
	local v46 = useNavigationProps(function(_, p4) -- line: 86
		return {
			isOmni = p4.isOmni,
			sortName = p4.sortName
		}
	end)
	local v47 = useDispatch()
	local v48 = useRoactService(RoactNetworking)
	local v49 = useTokens()
	local v50 = useSelector(function(p5) -- line: 97
		-- upvalues: TopicContentsReducer (copy)
		return p5.Personalization[TopicContentsReducer.key]
	end)
	local v51 = useSelector(function(p6) -- line: 101
		-- upvalues: v46 (copy), AppPage (copy)
		if v46.isOmni then
			return p6.OmniRecommendations and (p6.OmniRecommendations[AppPage.Home] and p6.OmniRecommendations[AppPage.Home].sorts)
		end

		return nil
	end)
	local v52 = useSelector(function(p7) -- line: 111
		-- upvalues: TopicContentsReducer (copy), v46 (copy), FetchStatusNamespace (copy), AppPage (copy), GameSortGroups (copy), FetchStatusReducer (copy), RetrievalStatus (copy)
		if not p7.Personalization[TopicContentsReducer.key][v46.sortName] then
			local OmniRecommendations, Home

			if v46.isOmni then
				OmniRecommendations = FetchStatusNamespace.OmniRecommendations
				Home = AppPage.Home
			else
				OmniRecommendations = FetchStatusNamespace.GameSortToken
				Home = GameSortGroups.GamesList
			end

			return p7.Personalization[FetchStatusReducer.key][OmniRecommendations][Home]
		end

		return RetrievalStatus.Done
	end)
	local v53 = React.useRef(nil)
	local v54 = React.useCallback(function() -- line: 132
		-- upvalues: v53 (copy)
		if v53.current then
			task.cancel(v53.current)
			v53.current = nil
		end
	end, {})

	React.useEffect(function() -- line: 140
		-- upvalues: v52 (copy), RetrievalStatus (copy), v46 (copy), v47 (copy), RefreshExpiringSortTokens (copy), v48 (copy), GameSortGroups (copy), v54 (copy), v50 (copy), LoggingProtocol (copy), sortDeeplinkFailureCounter (copy), FFlagSignalsNavP3Dispatch (copy), v35 (copy), NavigateBack (copy)
		if v52 == RetrievalStatus.NotStarted then
			if not v46.isOmni then
				v47(RefreshExpiringSortTokens(v48, { GameSortGroups.GamesList }))

				return
			end
		elseif v52 == RetrievalStatus.Done then
			v54()

			if not v50[v46.sortName] then
				LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
					reason = "InvalidSort",
					sortName = v46.sortName,
					isOmni = v46.isOmni
				})

				if FFlagSignalsNavP3Dispatch then
					v35.back()

					return
				end

				v47(NavigateBack())

				return
			end
		elseif v52 == RetrievalStatus.Failed then
			v54()
			LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
				reason = "SortTokenFetchFailed",
				sortName = v46.sortName,
				isOmni = v46.isOmni
			})

			if FFlagSignalsNavP3Dispatch then
				v35.back()

				return
			end

			v47(NavigateBack())
		end
	end, {
		v46.sortName,
		v46.isOmni,
		v52,
		v50,
		v47,
		v48,
		v54
	})
	React.useEffect(function() -- line: 189
		-- upvalues: v37 (copy), v53 (copy), LoggingProtocol (copy), sortDeeplinkFailureCounter (copy), v46 (copy), FFlagSignalsNavP3Dispatch (copy), v35 (copy), v47 (copy), NavigateBack (copy), v54 (copy)
		local v75 = v37

		if v75 >= 0 then
			v53.current = task.delay(v75, function() -- line: 193
				-- upvalues: LoggingProtocol (copy), sortDeeplinkFailureCounter (copy), v46 (copy), FFlagSignalsNavP3Dispatch (copy), v35 (copy), v47 (copy), NavigateBack (copy)
				LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
					reason = "SortTokenFetchTimeout",
					sortName = v46.sortName,
					isOmni = v46.isOmni
				})

				if FFlagSignalsNavP3Dispatch then
					v35.back()

					return
				end

				v47(NavigateBack())
			end)
		end

		return function() -- line: 208
			-- upvalues: v54 (copy)
			v54()
		end
	end, {
		v46.sortName,
		v46.isOmni,
		v47,
		v54
	})

	local v55 = React.useMemo(function() -- line: 213
		-- upvalues: v46 (copy), v51 (copy)
		local sortName = v46.sortName
		local v77 = v51

		if not v77 then
			return nil
		end

		for v78, v79 in v77 do
			if sortName == tostring(v79.topicId) then
				return v78
			end
		end

		return nil
	end, {
		v46.sortName,
		v51
	})
	local v56 = React.createElement(LoadingStateContainer, {
		dataStatus = RetrievalStatus2.fromRawValue(v52),
		renderOnLoaded = function() -- line: 219
			-- upvalues: React (copy), GamesList (copy), v46 (copy), v55 (copy)
			return React.createElement(GamesList, {
				pageContext = "Deeplink",
				initialSortName = v46.sortName,
				initialSortIndex = v55,
				isOmni = v46.isOmni
			})
		end
	})
	local v57 = if not v36 then nil else v49.Color.Surface.Surface_0

	if v36 then
		return (React.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = v57.Color3,
			BackgroundTransparency = v57.Transparency
		}, {
			GamesList = v56
		}))
	end

	return v56
end
local function SduiChartsDeeplinkRedirectGuard(t1: {[any]: any}) -- line: 250
	-- upvalues: getChartsSortDetailPageKey (copy), useUiStatus (copy), React (copy), getSduiApiStore (copy), SignalsReact (copy), useDispatch (copy), UiStatus (copy), LoggingProtocol (copy), sortDeeplinkFailureCounter (copy), FFlagSignalsNavP3Dispatch (copy), v35 (copy), NavigateBack (copy), v37 (copy), SduiChartsSortDetailPage (copy)
	local sortId = t1.sortId
	local v60 = getChartsSortDetailPageKey(sortId)
	local v61 = useUiStatus(v60)
	local v62 = React.useCallback(function(p8) -- line: 255
		-- upvalues: getSduiApiStore (copy), v60 (copy)
		return getSduiApiStore().getRootConfig(v60, p8) ~= nil
	end, { v60 })
	local v63 = SignalsReact.useSignalState(v62)
	local v64 = useDispatch()
	local v65 = React.useRef(nil)
	local v66 = React.useCallback(function() -- line: 263
		-- upvalues: v65 (copy)
		if v65.current then
			task.cancel(v65.current)
			v65.current = nil
		end
	end, {})

	React.useEffect(function() -- line: 270
		-- upvalues: v61 (copy), UiStatus (copy), v66 (copy), LoggingProtocol (copy), sortDeeplinkFailureCounter (copy), sortId (copy), FFlagSignalsNavP3Dispatch (copy), v35 (copy), v64 (copy), NavigateBack (copy), v63 (copy)
		if v61 == UiStatus.Error then
			v66()
			LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
				reason = "SortTokenFetchFailed",
				isOmni = false,
				sortName = sortId
			})

			if FFlagSignalsNavP3Dispatch then
				v35.back()

				return
			end

			v64(NavigateBack())

			return
		end

		if v61 == UiStatus.Resolved and not v63 then
			v66()
			LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
				reason = "InvalidSort",
				isOmni = false,
				sortName = sortId
			})

			if FFlagSignalsNavP3Dispatch then
				v35.back()

				return
			end

			v64(NavigateBack())

			return
		end

		if v61 == UiStatus.Resolved and v63 then
			v66()
		end
	end, {
		v61,
		v63,
		sortId,
		v64,
		v66
	})
	React.useEffect(function() -- line: 300
		-- upvalues: v37 (copy), v65 (copy), LoggingProtocol (copy), sortDeeplinkFailureCounter (copy), sortId (copy), FFlagSignalsNavP3Dispatch (copy), v35 (copy), v64 (copy), NavigateBack (copy), v66 (copy)
		local v81 = v37

		if v81 >= 0 then
			v65.current = task.delay(v81, function() -- line: 303
				-- upvalues: LoggingProtocol (copy), sortDeeplinkFailureCounter (copy), sortId (copy), FFlagSignalsNavP3Dispatch (copy), v35 (copy), v64 (copy), NavigateBack (copy)
				LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
					reason = "SortTokenFetchTimeout",
					isOmni = false,
					sortName = sortId
				})

				if FFlagSignalsNavP3Dispatch then
					v35.back()

					return
				end

				v64(NavigateBack())
			end)
		end

		return function() -- line: 317
			-- upvalues: v66 (copy)
			v66()
		end
	end, {
		sortId,
		v64,
		v66
	})

	return React.createElement(SduiChartsSortDetailPage, {
		pageContext = "Deeplink",
		sortId = sortId
	})
end

if FFlagLuaAppChartsAppPage then
	return function() -- line: 329
		-- upvalues: useNavigationProps (copy), React (copy), SduiChartsDeeplinkRedirectGuard (copy), DeeplinkGamesListWrapper (copy)
		local v67 = useNavigationProps(function(_, p10) -- line: 330
			return {
				isOmni = p10.isOmni,
				sortName = p10.sortName
			}
		end)

		if not v67.isOmni then
			return React.createElement(SduiChartsDeeplinkRedirectGuard, {
				sortId = v67.sortName
			})
		end

		return React.createElement(DeeplinkGamesListWrapper)
	end
end

return DeeplinkGamesListWrapper
