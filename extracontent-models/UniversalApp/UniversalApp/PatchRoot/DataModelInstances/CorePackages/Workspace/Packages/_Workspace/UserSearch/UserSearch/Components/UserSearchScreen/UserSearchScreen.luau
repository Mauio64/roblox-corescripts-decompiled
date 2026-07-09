local HttpService = game:GetService("HttpService")
local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local React = require(UserSearchParent.React)
local AppPage = require(UserSearchParent.RobloxAppEnums).AppPage
local useStyle = require(UserSearchParent.UIBlox).Core.Style.useStyle
local FullscreenPageWithSafeArea = require(UserSearchParent.AppBlox).FullscreenPageWithSafeArea
local useNavigation = require(UserSearchParent.Navigation).useNavigation
local UserSearchHeaderBar = require(UserSearch.Components.UserSearchHeaderBar)
local Analytics = require(UserSearch.Analytics)
local EventNames = Analytics.EventNames
local useUserSearchAnalytics = Analytics.useUserSearchAnalytics
local FFlagLuaAppsDefaultSelection = require(UserSearchParent.SharedFlags).FFlagLuaAppsDefaultSelection

local function UserSearchScreen(t1: {[any]: any}) -- line: 35
	-- upvalues: useNavigation (copy), useStyle (copy), FFlagLuaAppsDefaultSelection (copy), React (copy), HttpService (copy), useUserSearchAnalytics (copy), EventNames (copy), AppPage (copy), FullscreenPageWithSafeArea (copy), UserSearchHeaderBar (copy)
	local renderUserSearchResults = t1.renderUserSearchResults
	local v17 = useNavigation()
	local v18 = useStyle()
	local Tokens = v18.Tokens
	local v20 = v17.getParam("searchKeyword")
	local v21 = v17.getParam("shouldShowUserSearchLandingPage")
	local v22 = v17.getParam("entryPoint")
	local u23, u24

	if FFlagLuaAppsDefaultSelection then
		u23 = React.useRef(HttpService:GenerateGUID(false))
		u24 = useUserSearchAnalytics({
			currentPage = v22,
			userSearchSessionId = u23.current
		})
	else
		u24 = useUserSearchAnalytics({
			currentPage = v22
		})
		u23 = u24.getInfoForAllEvents().userSearchSessionId
	end

	React.useEffect(function() -- line: 61
		-- upvalues: v21 (copy), u24 (ref), EventNames (copy)
		if v21 then
			u24.fireAnalyticsEvent(EventNames.UserSearchBarOpen)
		end
	end, {})

	local v25 = React.useCallback(function(p1) -- line: 67
		-- upvalues: v17 (copy), AppPage (copy), v22 (copy), u24 (ref), EventNames (copy)
		v17.replace(AppPage.UserSearch, {
			searchKeyword = p1,
			entryPoint = v22
		})
		u24.fireAnalyticsEvent(EventNames.UserSearchBarSubmit, {
			kwd = p1
		})
	end, { v22 })
	local v26 = React.useCallback(function() -- line: 76
		-- upvalues: v17 (copy), u24 (ref), EventNames (copy)
		v17.pop()
		u24.fireAnalyticsEvent(EventNames.UserSearchBarCancel)
	end, {})
	local v27 = React.useMemo(function() -- line: 83
		-- upvalues: renderUserSearchResults (copy), v20 (copy), v21 (copy), FFlagLuaAppsDefaultSelection (copy), u23 (ref)
		return renderUserSearchResults({
			searchKeyword = v20,
			shouldShowUserSearchLandingPage = v21,
			searchUuid = if not FFlagLuaAppsDefaultSelection then u23 else u23.current
		})
	end, {
		v20,
		v21,
		u23
	})

	return React.createElement(FullscreenPageWithSafeArea, {
		includeStatusBar = true,
		BackgroundColor3 = v18.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v18.Theme.BackgroundDefault.Transparency,
		buttonRef = if not FFlagLuaAppsDefaultSelection then nil else t1.containerRef
	}, {
		UserSearchHeaderBar = React.createElement(UserSearchHeaderBar, {
			searchKeyword = v20,
			focusOnSearchInput = v21,
			onSubmitSearch = v25,
			onBackClick = v26,
			headerHeight = Tokens.Size.Size_1200
		}),
		PageContent = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 0, Tokens.Size.Size_1200),
			Size = UDim2.new(1, 0, 1, -Tokens.Size.Size_1200)
		}, {
			UserSearchPage = v27
		})
	})
end

return UserSearchScreen
