local NavigationRodux = script:FindFirstAncestor("NavigationRodux")

require(NavigationRodux.Parent.Navigation)

require(NavigationRodux.types)

local function selectNavigationState(p) -- 4 equivalent calls inferred from this helper
	return p.Navigation
end

local function selectLegacyHistory(p) -- 1 equivalent call inferred from this helper
	return selectNavigationState(p).history -- inferred equivalent call
end

local function selectCurrentLegacyRoute(p) -- 1 equivalent call inferred from this helper
	local history = selectLegacyHistory(p) -- inferred equivalent call
	return history[#history]
end

local function selectCurrentLegacyPage(p) -- 1 equivalent call inferred from this helper
	local currentLegacyRoute = selectCurrentLegacyRoute(p) -- inferred equivalent call
	return currentLegacyRoute[#currentLegacyRoute]
end

local Selectors = {}

function Selectors.selectCurrentRoactNavigationRoute(p)
	return selectNavigationState(p).currentRoute -- inferred equivalent call
end

Selectors.selectLegacyHistory = selectLegacyHistory

function Selectors.selectNavigationLocked(p)
	return selectNavigationState(p).lockNavigationActions -- inferred equivalent call
end

function Selectors.selectBackNavigationDisableCounter(p)
	return selectNavigationState(p).backNavigationDisableCounter -- inferred equivalent call
end

function Selectors.selectCurrentPageName(p)
	return selectCurrentLegacyPage(p).name -- inferred equivalent call
end

Selectors.selectCurrentLegacyRoute = selectCurrentLegacyRoute
Selectors.selectCurrentLegacyPage = selectCurrentLegacyPage
return Selectors
