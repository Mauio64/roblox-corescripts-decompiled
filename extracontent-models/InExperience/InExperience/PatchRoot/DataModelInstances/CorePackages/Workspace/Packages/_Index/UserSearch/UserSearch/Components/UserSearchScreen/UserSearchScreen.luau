local HttpService = game:GetService("HttpService")

local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

local React = require(parent.React)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local AppBlox = require(parent.AppBlox)
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local UserSearchHeaderBar = require(UserSearch.Components.UserSearchHeaderBar)

local Analytics = require(UserSearch.Analytics)
local EventNames = Analytics.EventNames
local useUserSearchAnalytics = Analytics.useUserSearchAnalytics

local function UserSearchScreen(p)
	local renderUserSearchResults = p.renderUserSearchResults

	local v = useNavigation()

	local v2 = useStyle()
	local tokens = v2.Tokens

	local param = v.getParam("searchKeyword")
	local param2 = v.getParam("shouldShowUserSearchLandingPage")
	local param3 = v.getParam("entryPoint")

	local ref = React.useRef(HttpService:GenerateGUID(false))
	local v3 = useUserSearchAnalytics({ currentPage = param3, userSearchSessionId = ref.current })

	React.useEffect(function()
		if param2 then
			v3.fireAnalyticsEvent(EventNames.UserSearchBarOpen)
		end
	end, {})

	local onSubmitSearch = React.useCallback(function(p2)
		v.replace(AppPage.UserSearch, { searchKeyword = p2, entryPoint = param3 })

		v3.fireAnalyticsEvent(EventNames.UserSearchBarSubmit, { kwd = p2 })
	end, { param3 })

	local onBackClick = React.useCallback(function()
		v.pop()

		v3.fireAnalyticsEvent(EventNames.UserSearchBarCancel)
	end, {})

	local userSearchPage = React.useMemo(function()
		return renderUserSearchResults({
			searchKeyword = param,
			shouldShowUserSearchLandingPage = param2,
			searchUuid = ref.current
		})
	end, { param, param2, ref })

	return React.createElement(
		FullscreenPageWithSafeArea,
		{
			includeStatusBar = true,
			BackgroundColor3 = v2.Theme.BackgroundDefault.Color,
			BackgroundTransparency = v2.Theme.BackgroundDefault.Transparency,
			buttonRef = p.containerRef
		},
		{
			UserSearchHeaderBar = React.createElement(UserSearchHeaderBar, {
				searchKeyword = param,
				focusOnSearchInput = param2,
				onSubmitSearch = onSubmitSearch,
				onBackClick = onBackClick,
				headerHeight = tokens.Size.Size_1200
			}),
			PageContent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, tokens.Size.Size_1200),
				Size = UDim2.new(1, 0, 1, -tokens.Size.Size_1200)
			}, { UserSearchPage = userSearchPage })
		}
	)
end

return UserSearchScreen
