local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local AppPage = require(Modules.LuaApp.AppPage)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local AvatarExperienceActions = require(Modules.AvatarExperience.Common.Components.RoactNavigation.AvatarExperienceActions)
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local t1 = {
	[AppPage.AvatarExperienceWrapper] = true,
	[AppPage.AvatarExperienceWrapperTransparent] = true
}

local function buildHistoryFromRoute(p1) -- line: 25
	local t2 = {}

	for i = 1, #p1 do
		local t3 = {}

		for j = 1, i do
			table.insert(t3, p1[j])
		end

		table.insert(t2, t3)
	end

	return t2
end
local function getPageName(p2) -- line: 37
	-- upvalues: AppPage (copy)
	local name = p2.name

	if name == AppPage.AvatarExperienceWrapper or name == AppPage.AvatarExperienceWrapperTransparent then
		name = p2.extraProps and p2.extraProps.routeName or nil
	end

	return name
end
local function closeAppRouterPages(p3, p4) -- line: 45
	-- upvalues: Cryo (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AppPage (copy), buildHistoryFromRoute (copy), ResetNavigationHistory (copy)
	local v23 = Cryo.List.toSet(p4)
	local v24 = p3:getState()
	local v25 = if not FFlagUseNavigationSelectors then v24.Navigation.history[#v24.Navigation.history] else Selectors.selectCurrentLegacyRoute(v24)
	local t4 = {}
	local v27 = false

	for i = 1, #v25 do
		local v29 = v25[i]
		local name = v29.name

		if name == AppPage.AvatarExperienceWrapper or name == AppPage.AvatarExperienceWrapperTransparent then
			name = v29.extraProps and v29.extraProps.routeName or nil
		end

		if v23[name] then
			v27 = true
		else
			table.insert(t4, v25[i])
		end
	end

	if not v27 then
		return
	end

	local v31 = buildHistoryFromRoute(t4)

	p3:dispatch(ResetNavigationHistory(nil, v31))
end
local function getCurrentAppRouterPageName(p5) -- line: 71
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy)
	local v33 = p5:getState()
	local v34

	if FFlagUseNavigationSelectors then
		v34 = Selectors.selectCurrentLegacyPage(v33)
	else
		local v35 = v33.Navigation.history[#v33.Navigation.history]

		v34 = v35[#v35]
	end

	return v34.name
end

return function(p6, p7) -- line: 83
	-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), t1 (copy), closeAppRouterPages (copy), AvatarExperienceActions (copy)
	return function(p8) -- line: 84
		-- upvalues: FFlagUseNavigationSelectors (copy), Selectors (copy), t1 (copy), closeAppRouterPages (copy), p7 (copy), p6 (copy), AvatarExperienceActions (copy)
		local v39 = p8:getState()
		local v40

		if FFlagUseNavigationSelectors then
			v40 = Selectors.selectCurrentLegacyPage(v39)
		else
			local v41 = v39.Navigation.history[#v39.Navigation.history]

			v40 = v41[#v41]
		end

		if t1[v40.name] then
			closeAppRouterPages(p8, p7)

			return
		end

		p6.dispatch(AvatarExperienceActions.clearScreens(p7))
	end
end
