local unifiedEventPageStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Store.UnifiedEventPageStore
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local getLegacyNavigationStore = NavigationRodux.GetLegacyNavigationStore
local selectors = NavigationRodux.Selectors
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local appPage = RobloxAppEnums.AppPage
local switchTab = RobloxAppEnums.SwitchTab
local fFlagSignalsNavP3Final = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Final

local module3 = require("@luauforge/bundled/dGJ")

local function isAvatarExperienceWrapper(p2): boolean
	return p2 == appPage.AvatarExperienceWrapper or p2 == appPage.AvatarExperienceWrapperTransparent
end

local function isAvatarExperience(p2): boolean
	return p2 == avatarScreen.AvatarExperienceRoot or p2 == switchTab.AvatarExperienceTab
end

local function hostPageName(list)
	for i = #list, 1, -1 do
		local item = list[i]
		local name = item.name

		if not (name ~= appPage.AvatarExperienceWrapper and name ~= appPage.AvatarExperienceWrapperTransparent) then
			continue
		end

		local v5 = module3[item.name]

		if v5 == nil or not v5.renderUnderlyingPage then
			return item.name
		end
	end

	return nil
end

local function avatarScreenName(p2, p3)
	local name = p3.name

	if name == appPage.AvatarExperienceWrapper or name == appPage.AvatarExperienceWrapperTransparent then
		local extraProps = p3.extraProps

		if extraProps == nil then
			return nil
		end

		return extraProps.routeName
	else
		local avatarExperience = p2.AvatarExperience
		local avatarScene = if avatarExperience ~= nil then avatarExperience.AvatarScene else nil
		local avatarRoute = if avatarScene ~= nil then avatarScene.AvatarRoute else nil
		local current = if avatarRoute ~= nil then avatarRoute.current else nil

		if current == nil or current.name == avatarScreen.None then
			return nil
		end

		return current.name
	end
end

local function currentLegacyRoute(p2)
	if fFlagSignalsNavP3Final then
		return getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
	end

	return selectors.selectCurrentLegacyRoute(p2)
end

local function resolvePages(p2)
	local v5

	if fFlagSignalsNavP3Final then
		v5 = getLegacyNavigationStore(false).getCurrentLegacyRoute(false)
	else
		v5 = selectors.selectCurrentLegacyRoute(p2)
	end

	if v5 == nil or #v5 == 0 then
		return nil, nil
	end

	local v6 = v5[#v5]
	local v7 = v6.name
	local name = v6.name

	if name == appPage.AvatarExperienceWrapper or name == appPage.AvatarExperienceWrapperTransparent then
		v7 = avatarScreenName(p2, v6) or v6.name
	else
		local name2 = v6.name

		if name2 == avatarScreen.AvatarExperienceRoot or name2 == switchTab.AvatarExperienceTab then
			v7 = avatarScreenName(p2, v6) or v6.name
		end
	end

	return v7, hostPageName(v5)
end

local function registerUnifiedEventPageResolver(object)
	unifiedEventPageStore.setPageProvider(function()
		return resolvePages(object:getState())
	end)
end

return registerUnifiedEventPageResolver
