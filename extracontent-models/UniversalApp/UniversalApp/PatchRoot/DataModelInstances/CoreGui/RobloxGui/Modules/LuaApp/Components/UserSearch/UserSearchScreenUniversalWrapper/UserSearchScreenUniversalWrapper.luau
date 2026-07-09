local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UserSearchScreen = require(Modules.LuaApp.Components.UserSearch.api).UserSearchScreen
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local PlayerSearch = require(script.Parent.Parent.Players.PlayerSearch)
local FFlagLuaAppSearchPeopleUnifiedSchemaFields = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSearchPeopleUnifiedSchemaFields
local FFlagLuaAppsDefaultSelection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsDefaultSelection
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusOnMount = require(CorePackages.Workspace.Packages.FocusNavigationUtils).useFocusOnMount

local function UserSearchScreenUniversalWrapper() -- line: 22
	-- upvalues: FFlagLuaAppsDefaultSelection (copy), ReactFocusNavigation (copy), useFocusOnMount (copy), React (copy), PlayerSearch (copy), FFlagLuaAppSearchPeopleUnifiedSchemaFields (copy), AppPage (copy), UserSearchScreen (copy)
	local u12 = nil
	local v13 = nil

	if FFlagLuaAppsDefaultSelection then
		local v14

		v14, v13 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()
		u12 = useFocusOnMount(v14)
	end

	local v15 = React.useCallback(function(t1: {[any]: any}) -- line: 29
		-- upvalues: React (copy), PlayerSearch (copy), FFlagLuaAppSearchPeopleUnifiedSchemaFields (copy), AppPage (copy), FFlagLuaAppsDefaultSelection (copy), u12 (ref)
		local searchKeyword = t1.searchKeyword
		local shouldShowUserSearchLandingPage = t1.shouldShowUserSearchLandingPage
		local searchUuid = t1.searchUuid

		return React.createElement(PlayerSearch, {
			searchParameters = {
				searchKeyword = searchKeyword
			},
			shouldShowUserSearchLandingPage = shouldShowUserSearchLandingPage,
			searchUuid = searchUuid,
			appPage = if not FFlagLuaAppSearchPeopleUnifiedSchemaFields then nil else AppPage.UserSearch,
			defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else u12
		})
	end, { if not FFlagLuaAppsDefaultSelection then nil else u12 })

	return React.createElement(UserSearchScreen, {
		renderUserSearchResults = v15,
		containerRef = if not FFlagLuaAppsDefaultSelection then nil else v13
	})
end

return UserSearchScreenUniversalWrapper
