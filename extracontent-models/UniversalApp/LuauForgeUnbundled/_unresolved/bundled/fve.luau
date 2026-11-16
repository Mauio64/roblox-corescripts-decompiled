local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/dHq")

local avatarExperienceActions = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Actions.AvatarExperienceActions
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore

local set = {
	[module.AvatarExperienceWrapper] = true,
	[module.AvatarExperienceWrapperTransparent] = true
}

local function buildHistoryFromRoute(list)
	local historyFromRoute = {}

	for i = 1, #list do
		local v5 = {}

		for j = 1, i do
			table.insert(v5, list[j])
		end

		table.insert(historyFromRoute, v5)
	end

	return historyFromRoute
end

local function getPageName(p2)
	local pageName = p2.name

	if
		pageName == module.AvatarExperienceWrapper
		or pageName == module.AvatarExperienceWrapperTransparent
	then
		pageName = p2.extraProps and p2.extraProps.routeName or nil
	end

	return pageName
end

local function closeAppRouterPages(object, p2)
	local set2 = Cryo.List.toSet(p2)
	local state = object:getState()
	local v5

	if fFlagSignalsNavP3gAvatarExperience then
		v5 = getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
	elseif fFlagUseNavigationSelectors then
		v5 = selectors.selectCurrentLegacyRoute(state)
	else
		v5 = state.Navigation.history[#state.Navigation.history]
	end

	local v6 = {}
	local v7 = false

	for i = 1, #v5 do
		local v8 = v5[i]
		local v9 = v8.name

		if v9 == module.AvatarExperienceWrapper or v9 == module.AvatarExperienceWrapperTransparent then
			v9 = v8.extraProps and v8.extraProps.routeName or nil
		end

		if set2[v9] then
			v7 = true
		else
			table.insert(v6, v5[i])
		end
	end

	if not v7 then
		return
	end

	object:dispatch(module2(nil, buildHistoryFromRoute(v6)))
end

local function getCurrentAppRouterPageName(object)
	local state = object:getState()
	local v5

	if fFlagSignalsNavP3gAvatarExperience then
		v5 = getLegacyNavigationStore(false).getCurrentPage(false)
	elseif fFlagUseNavigationSelectors then
		v5 = selectors.selectCurrentLegacyPage(state)
	else
		local v6 = state.Navigation.history[#state.Navigation.history]
		v5 = v6[#v6]
	end

	return v5.name
end

return function(p2, p3)
	return function(p4)
		if set[getCurrentAppRouterPageName(p4)] then
			closeAppRouterPages(p4, p3)
		else
			p2.dispatch(avatarExperienceActions.clearScreens(p3))
		end
	end
end
