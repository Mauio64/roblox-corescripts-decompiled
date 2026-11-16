local userSearchScreen = require("@luauforge/bundled/edF").UserSearchScreen

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local module = require("@luauforge/deferred/ecQ")

local fFlagLuaAppSearchPeopleUnifiedSchemaFields = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSearchPeopleUnifiedSchemaFields
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusOnMount = require("@luauforge/bundled/eeo").useFocusOnMount

local function UserSearchScreenUniversalWrapper()
	local v5, v6 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()
	local v7 = useFocusOnMount(v5)
	local v8 = React.useCallback(function(props)
		local searchKeyword = props.searchKeyword
		local shouldShowUserSearchLandingPage = props.shouldShowUserSearchLandingPage
		local searchUuid = props.searchUuid

		local createElement = React.createElement

		local v11 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then appPage.UserSearch else nil
		return createElement(module, {
			searchParameters = { searchKeyword = searchKeyword },
			shouldShowUserSearchLandingPage = shouldShowUserSearchLandingPage,
			searchUuid = searchUuid,
			appPage = v11,
			defaultFocusRef = v7
		})
	end, { v7 })

	return React.createElement(userSearchScreen, {
		renderUserSearchResults = v8,
		containerRef = v6
	})
end

return UserSearchScreenUniversalWrapper
