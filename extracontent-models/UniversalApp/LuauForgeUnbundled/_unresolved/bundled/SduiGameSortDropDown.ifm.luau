local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local gameSortGroups = require("@luauforge/bundled/cBc").GameSortGroups
local getSduiClientPageScope = require("@luauforge/bundled/dXB").getSduiClientPageScope

require("@luauforge/bundled/ifl")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local navigateDown = NavigationRodux.Thunks.NavigateDown
local navigateFromWebView = NavigationRodux.Thunks.NavigateFromWebView

local module2 = require("@luauforge/bundled/hPr")
local useHomeSortDropDownOptions = require("@luauforge/bundled/fzZ").useHomeSortDropDownOptions

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagLuaAppEnableSduiHomePage = SharedFlags.FFlagLuaAppEnableSduiHomePage

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dFz").NavigationCommands else nil

local v5 = {
	OMNI_HOME = { sortType = appPage.Home, isOmni = true },
	GAMES = { sortType = gameSortGroups.GamesList, isOmni = false }
}

local function SduiGameSortDropDown(props)
	local sduiContext = props.sduiContext
	local dispatch = sduiContext.dependencies.dispatch
	local gameAnalytics = sduiContext.dependencies.gameAnalytics
	local v6 = if fFlagLuaAppEnableSduiHomePage then useHomeSortDropDownOptions() else nil

	local v7 = React.useCallback(function(data, p2, p3)
		if data.topicId == nil then
			gameAnalytics.reportFilterChangeWithId(data.gameSetTypeId, data.gameSetTargetId, p3)

			local v8 = {
				name = appPage.GamesList,
				detail = data.name,
				extraProps = { pageContext = sduiContext.appPage }
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.fromWebView(navigationCommands.fromLegacyPage(v8))
			else
				dispatch(navigateFromWebView(v8))
			end
		else
			gameAnalytics.reportFilterChangeWithId(data.topicId, nil, p3)
			local v8 = {
				name = appPage.GamesList,
				detail = tostring(data.topicId),
				extraProps = {
					pageContext = appPage.Home,
					isOmni = true,
					sortIndex = p2
				}
			}

			if fFlagLuaAppEnableSduiHomePage then
				if fFlagSignalsNavP3Dispatch then
					navigationCommands.fromWebView(navigationCommands.fromLegacyPage(v8))
				else
					dispatch(navigateFromWebView(v8))
				end
			elseif fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v8))
			else
				dispatch(navigateDown(v8))
			end
		end
	end, { dispatch, gameAnalytics, sduiContext })

	local configKey = sduiContext.configKey

	local selectedSortId = if configKey ~= nil then getSduiClientPageScope(configKey).get("selectedSortId") else nil
	local selectedSortIndex

	if fFlagLuaAppEnableSduiHomePage and configKey ~= nil then
		selectedSortIndex = getSduiClientPageScope(configKey).get("selectedSortIndex")
	end

	local createElement = React.createElement
	local v9 = {
		sortCategories = v5,
		selectedSortName = selectedSortId,
		selectedSortIndex = nil,
		omniSortOptions = nil,
		isOmni = 0,
		includeOmniSorts = 0,
		position = 0,
		size = 0,
		onSelected = 0
	}

	if not fFlagLuaAppEnableSduiHomePage then
		selectedSortIndex = nil
	end

	v9.selectedSortIndex = selectedSortIndex

	if not fFlagLuaAppEnableSduiHomePage then
		v6 = nil
	end

	v9.omniSortOptions = v6

	v9.isOmni = props.isOmni
	v9.includeOmniSorts = props.includeOmniSorts
	v9.position = props.position
	v9.size = props.size
	v9.onSelected = v7
	return createElement(module2, v9)
end

return SduiGameSortDropDown
