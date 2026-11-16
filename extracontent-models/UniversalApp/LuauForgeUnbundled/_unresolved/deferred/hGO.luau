local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local gameSortGroups = require("@luauforge/bundled/cyO").GameSortGroups
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Thunks.NavigateBack
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local topicContentsReducer = require("@luauforge/bundled/dzJ").TopicContentsReducer

local refreshExpiringSortTokens = require("@luauforge/bundled/dpZ").Modules.LuaApp.Thunks.Games.RefreshExpiringSortTokens

local module3 = require("@luauforge/bundled/dzM")
local fetchStatusReducer = module3.FetchStatusReducer
local fetchStatusNamespace = module3.FetchStatusNamespace
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus

local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens

local UIBlox = require(CorePackages.Packages.UIBlox)
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local retrievalStatus2 = UIBlox.App.Loading.Enum.RetrievalStatus

local module4 = require("@luauforge/deferred/hEp")
local module5 = require("@luauforge/deferred/hEG")

local getChartsSortDetailPageKey = require("@luauforge/bundled/fBm").getChartsSortDetailPageKey

local module6 = require("@luauforge/bundled/dUe")
local getSduiApiStore = module6.getSduiApiStore
local useUiStatus = module6.useUiStatus
local uiStatus = module6.UiStatus

local SignalsReact = require(CorePackages.Packages.SignalsReact)

local sortDeeplinkFailureCounter = require("@luauforge/bundled/dwD").Events.sortDeeplinkFailureCounter
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigationProps = require("@luauforge/bundled/dCu").useNavigationProps
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage
local fFlagLuaAppSduiHomePageSupport = SharedFlags.FFlagLuaAppSduiHomePageSupport

local v5 = if fFlagLuaAppSduiHomePageSupport then require("@luauforge/deferred/hEO") else nil

local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dCu").NavigationCommands
else
	navigationCommands = nil
end

local defineFastFlag = game:DefineFastFlag("LuaAppDeeplinkGamesListWrapperFixBackgroundColor", false)

local module7 = require("@luauforge/bundled/hEJ")
local useThemeBackground = require("@luauforge/bundled/eeu").useThemeBackground

local defineFastInt = game:DefineFastInt("LuaAppSortDeeplinkFetchingTimeoutInSec", 10)

local v6 = {
	InvalidSort = "InvalidSort",
	SortTokenFetchFailed = "SortTokenFetchFailed",
	SortTokenFetchTimeout = "SortTokenFetchTimeout"
}

local function getSortIndex(p2, items)
	if not items then
		return nil
	end

	for k, item in items do
		if tostring(item.topicId) == p2 then
			return k
		end
	end

	return nil
end

local function DeeplinkGamesListWrapper()
	local v7 = useNavigationProps(function(p2, p3)
		return { isOmni = p3.isOmni, sortName = p3.sortName }
	end)

	local v8 = useDispatch()
	local v9 = useRoactService(roactNetworking)
	local v10 = useTokens()

	local v11 = useSelector(function(p2)
		return p2.Personalization[topicContentsReducer.key]
	end)

	local v12 = useSelector(function(p2)
		if v7.isOmni then
			return p2.OmniRecommendations
				and p2.OmniRecommendations[appPage.Home]
				and p2.OmniRecommendations[appPage.Home].sorts
		end

		return nil
	end)

	local v13 = useSelector(function(p2)
		if p2.Personalization[topicContentsReducer.key][v7.sortName] then
			return retrievalStatus.Done
		end

		local v14, v15

		if v7.isOmni then
			v14 = fetchStatusNamespace.OmniRecommendations
			v15 = appPage.Home
		else
			v14 = fetchStatusNamespace.GameSortToken
			v15 = gameSortGroups.GamesList
		end

		return p2.Personalization[fetchStatusReducer.key][v14][v15]
	end)

	local ref = React.useRef(nil)

	local v14 = React.useCallback(function()
		if ref.current then
			task.cancel(ref.current)
			ref.current = nil
		end
	end, {})

	React.useEffect(function()
		if v13 == retrievalStatus.NotStarted then
			if not v7.isOmni then
				v8(refreshExpiringSortTokens(v9, { gameSortGroups.GamesList }))
			end
		elseif v13 == retrievalStatus.Done then
			v14()

			if not v11[v7.sortName] then
				LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
					reason = "InvalidSort",
					sortName = v7.sortName,
					isOmni = v7.isOmni
				})

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.back()
				else
					v8(navigateBack())
				end
			end
		elseif v13 == retrievalStatus.Failed then
			v14()

			LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
				reason = "SortTokenFetchFailed",
				sortName = v7.sortName,
				isOmni = v7.isOmni
			})

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back()
			else
				v8(navigateBack())
			end
		end
	end, { v7.sortName, v7.isOmni, v13, v11, v8, v9, v14 })

	React.useEffect(function()
		local v15 = defineFastInt

		if v15 >= 0 then
			ref.current = task.delay(v15, function()
				LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
					reason = "SortTokenFetchTimeout",
					sortName = v7.sortName,
					isOmni = v7.isOmni
				})

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.back()
				else
					v8(navigateBack())
				end
			end)
		end

		return function()
			v14()
		end
	end, { v7.sortName, v7.isOmni, v8, v14 })

	local v15 = React.useMemo(function()
		local sortName = v7.sortName
		local v16 = v12

		if not v16 then
			return nil
		end

		for k, v17 in v16 do
			if tostring(v17.topicId) == sortName then
				return k
			end
		end

		return nil
	end, { v7.sortName, v12 })

	local element = React.createElement(loadingStateContainer, {
		dataStatus = retrievalStatus2.fromRawValue(v13),
		renderOnLoaded = function()
			return React.createElement(module4, {
				pageContext = "Deeplink",
				initialSortName = v7.sortName,
				initialSortIndex = v15,
				isOmni = v7.isOmni
			})
		end
	})

	local surface_0 = if defineFastFlag then v10.Color.Surface.Surface_0 else nil

	local v16 = if module7 then useThemeBackground() ~= nil else false

	if defineFastFlag then
		return (React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = surface_0.Color3,
			BackgroundTransparency = v16 and 1 or surface_0.Transparency,
			BorderSizePixel = 0
		}, { GamesList = element }))
	end

	return element
end

local function SduiChartsDeeplinkRedirectGuard(p2)
	local sortId = p2.sortId
	local chartsSortDetailPageKey = getChartsSortDetailPageKey(sortId)

	local v7 = useUiStatus(chartsSortDetailPageKey)
	local v8 = React.useCallback(function(p3): boolean
		return getSduiApiStore().getRootConfig(chartsSortDetailPageKey, p3) ~= nil
	end, { chartsSortDetailPageKey })
	local v9 = SignalsReact.useSignalState(v8)

	local v10 = useDispatch()
	local ref = React.useRef(nil)

	local v11 = React.useCallback(function()
		if ref.current then
			task.cancel(ref.current)
			ref.current = nil
		end
	end, {})

	React.useEffect(function()
		if v7 == uiStatus.Error then
			v11()
			LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
				reason = "SortTokenFetchFailed",
				sortName = sortId,
				isOmni = false
			})

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back()
			else
				v10(navigateBack())
			end
		elseif v7 == uiStatus.Resolved and not v9 then
			v11()
			LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
				reason = "InvalidSort",
				sortName = sortId,
				isOmni = false
			})

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back()
			else
				v10(navigateBack())
			end
		elseif v7 == uiStatus.Resolved and v9 then
			v11()
		end
	end, { v7, v9, sortId, v10, v11 })

	React.useEffect(function()
		local v12 = defineFastInt

		if v12 >= 0 then
			ref.current = task.delay(v12, function()
				LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
					reason = "SortTokenFetchTimeout",
					sortName = sortId,
					isOmni = false
				})

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.back()
				else
					v10(navigateBack())
				end
			end)
		end

		return function()
			v11()
		end
	end, { sortId, v10, v11 })

	return React.createElement(module5, { sortId = sortId, pageContext = "Deeplink" })
end

return function()
	local v7 = useNavigationProps(function(p2, p3)
		return { isOmni = p3.isOmni, sortName = p3.sortName }
	end)

	if fFlagLuaAppSduiHomePageSupport and fFlagLuaAppEnableSduiHomePage and v7.isOmni then
		return React.createElement(v5, {
			sortId = v7.sortName,
			pageContext = "Deeplink"
		})
	end

	if v7.isOmni then
		return React.createElement(DeeplinkGamesListWrapper)
	end

	return React.createElement(SduiChartsDeeplinkRedirectGuard, { sortId = v7.sortName })
end
