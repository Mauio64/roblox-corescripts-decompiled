local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/React")

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/RobloxAppEnums").AppPage

local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/UIBlox").Core.Style.useStyle
local fullscreenPageWithSafeArea = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/AppBlox").FullscreenPageWithSafeArea

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/Navigation").useNavigation

local module2 = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Components/UserSearchHeaderBar")

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Analytics")
local eventNames = Analytics.EventNames
local useUserSearchAnalytics = Analytics.useUserSearchAnalytics

local function UserSearchScreen(p2)
	local renderUserSearchResults = p2.renderUserSearchResults

	local v5 = useNavigation()

	local v6 = useStyle()
	local tokens = v6.Tokens

	local param = v5.getParam("searchKeyword")
	local param2 = v5.getParam("shouldShowUserSearchLandingPage")
	local param3 = v5.getParam("entryPoint")

	local ref = React.useRef(HttpService:GenerateGUID(false))
	local v7 = useUserSearchAnalytics({
		currentPage = param3,
		userSearchSessionId = ref.current
	})

	React.useEffect(function()
		if param2 then
			v7.fireAnalyticsEvent(eventNames.UserSearchBarOpen)
		end
	end, {})

	local v8 = React.useCallback(function(p3)
		v5.replace(appPage.UserSearch, { searchKeyword = p3, entryPoint = param3 })

		v7.fireAnalyticsEvent(eventNames.UserSearchBarSubmit, { kwd = p3 })
	end, { param3 })

	local v9 = React.useCallback(function()
		v5.pop()

		v7.fireAnalyticsEvent(eventNames.UserSearchBarCancel)
	end, {})

	local v10 = React.useMemo(function()
		return renderUserSearchResults({
			searchKeyword = param,
			shouldShowUserSearchLandingPage = param2,
			searchUuid = ref.current
		})
	end, { param, param2, ref })

	return React.createElement(
		fullscreenPageWithSafeArea,
		{
			includeStatusBar = true,
			BackgroundColor3 = v6.Theme.BackgroundDefault.Color,
			BackgroundTransparency = v6.Theme.BackgroundDefault.Transparency,
			buttonRef = p2.containerRef
		},
		{
			UserSearchHeaderBar = React.createElement(module2, {
				searchKeyword = param,
				focusOnSearchInput = param2,
				onSubmitSearch = v8,
				onBackClick = v9,
				headerHeight = tokens.Size.Size_1200
			}),
			PageContent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, tokens.Size.Size_1200),
				Size = UDim2.new(1, 0, 1, -tokens.Size.Size_1200)
			}, { UserSearchPage = v10 })
		}
	)
end

return UserSearchScreen
