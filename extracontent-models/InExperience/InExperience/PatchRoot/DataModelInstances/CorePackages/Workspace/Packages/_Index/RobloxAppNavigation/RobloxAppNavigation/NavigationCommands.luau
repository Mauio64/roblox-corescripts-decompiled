local parent = script:FindFirstAncestor("RobloxAppNavigation").Parent

local RoactNavigation = require(parent.RoactNavigation)

local AppNavigationRegistry = require(script.Parent.AppNavigationRegistry)
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavPendingLock = SharedFlags.FFlagSignalsNavPendingLock
local FFlagSignalsNavHomeFlowBegin = SharedFlags.FFlagSignalsNavHomeFlowBegin
local homePageLoadTracker

if FFlagSignalsNavHomeFlowBegin then
	local HomePageLoadTracker = require(parent.HomePageLoadTracker)
	homePageLoadTracker = HomePageLoadTracker.HomePageLoadTracker
else
	homePageLoadTracker = nil
end

local RobloxAppEnums = require(parent.RobloxAppEnums)
local Home = RobloxAppEnums.AppPage.Home

local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local trackStart = TimeToInteractiveTracker.TimeToInteractiveTracker.trackStart

local function isNavigationLocked(flag: boolean?) -- 6 equivalent calls inferred from this helper
	if FFlagSignalsNavPendingLock then
		return not flag and AppNavigationRegistry.isNavigationLocked(false)
	end

	return not flag and AppNavigationRegistry.get().getIsNavigating(false)
end

local function beginHomeVisitIfHome(p) -- 5 equivalent calls inferred from this helper
	if p and p.routeName == Home then
		homePageLoadTracker.beginVisit()
	end
end

local NavigationCommands = {}

function NavigationCommands.back(flag: boolean?)
	if isNavigationLocked(flag) then -- inferred equivalent call
		return
	end

	AppNavigationRegistry.get().dispatch(RoactNavigation.Actions.back())
end

function NavigationCommands.down(p, flag: boolean?)
	if isNavigationLocked(flag) then -- inferred equivalent call
		return
	end

	if trackStart then
		trackStart("NavigateTo_" .. p.routeName, true)
	end

	if FFlagSignalsNavHomeFlowBegin then
		beginHomeVisitIfHome(p) -- inferred equivalent call
	end

	AppNavigationRegistry.get().dispatch(RoactNavigation.StackActions.push(p))
end

function NavigationCommands.to(p, flag: boolean?)
	if isNavigationLocked(flag) then -- inferred equivalent call
		return
	end

	if trackStart then
		trackStart("NavigateTo_" .. p.routeName, true)
	end

	if FFlagSignalsNavHomeFlowBegin then
		beginHomeVisitIfHome(p) -- inferred equivalent call
	end

	AppNavigationRegistry.get().dispatch(RoactNavigation.Actions.navigate(p))
end

function NavigationCommands.sideways(p, flag: boolean?)
	if isNavigationLocked(flag) then -- inferred equivalent call
		return
	end

	if trackStart then
		trackStart("NavigateTo_" .. p.routeName, true)
	end

	if FFlagSignalsNavHomeFlowBegin then
		beginHomeVisitIfHome(p) -- inferred equivalent call
	end

	AppNavigationRegistry.get().dispatch(RoactNavigation.Actions.navigate(p))
end

function NavigationCommands.fromWebView(p, flag: boolean?)
	if isNavigationLocked(flag) then -- inferred equivalent call
		return
	end

	if trackStart then
		trackStart("NavigateTo_" .. p.routeName, true)
	end

	if FFlagSignalsNavHomeFlowBegin then
		beginHomeVisitIfHome(p) -- inferred equivalent call
	end

	AppNavigationRegistry.get().dispatch(RoactNavigation.StackActions.replace(p))
end

function NavigationCommands.resetStack(list, p, flag: boolean?)
	if isNavigationLocked(flag) then -- inferred equivalent call
		return
	end

	local actions = {}
	local wrapAction

	if p then
		wrapAction = p.wrapAction
	end

	for _, item in list do
		local v = RoactNavigation.Actions.navigate(item)

		v = wrapAction and wrapAction(v, item) or v

		table.insert(actions, v)
	end

	local v = trackStart and list[#list]

	if v then
		trackStart("NavigateTo_" .. v.routeName, true)
	end

	if FFlagSignalsNavHomeFlowBegin then
		beginHomeVisitIfHome(list[#list]) -- inferred equivalent call
	end

	AppNavigationRegistry.get().dispatch(RoactNavigation.StackActions.reset({
		index = #actions,
		actions = actions
	}))
end

function NavigationCommands.fromLegacyPage(p)
	local params = nil

	for k, v in p do
		if not (k ~= "name" and k ~= "rnKey" and k ~= "key") then
			continue
		end

		params = params == nil and {} or params

		params[k] = v
	end

	return {
		routeName = p.name,
		params = params,
		key = p.rnKey or p.key
	}
end

return NavigationCommands
