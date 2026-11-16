local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/RoactUtils")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local UserSearch = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/UserSearch")
local userSearchTile = UserSearch.UserSearchTile
local analytics = UserSearch.Analytics.Analytics
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/NavigationRodux").Thunks.NavigateDown
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/RobloxAppEnums").AppPage
local UnifiedLogging = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/UnifiedLogging")

local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local calculateRowPositionFields = UnifiedLogging.calculateRowPositionFields

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagLuaAppSearchPeopleUnifiedSchemaFields = SharedFlags.FFlagLuaAppSearchPeopleUnifiedSchemaFields

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/RobloxAppNavigation").NavigationCommands else nil

local function SduiUserSearchTile(props)
	local v5 = useDispatch()
	local userId = props.userId

	local v6 = findAnalyticsFieldInAncestors("searchQuery", props.analyticsContext) or ""
	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors(
		"userSearchSessionId",
		props.analyticsContext
	)
	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("collectionId", props.analyticsContext)
	local analyticsFieldInAncestors3 = findAnalyticsFieldInAncestors(
		"collectionPosition",
		props.analyticsContext
	)
	local appPage2 = if props.sduiContext then props.sduiContext.appPage else nil

	local v7 = React.useMemo(function()
		return analytics({
			infoForAllEvents = {
				userSearchSessionId = analyticsFieldInAncestors,
				sortPosition = analyticsFieldInAncestors3,
				sortId = analyticsFieldInAncestors2,
				pageContext = appPage2
			}
		}).fireAnalyticsEvent
	end, {
		analyticsFieldInAncestors,
		analyticsFieldInAncestors3,
		analyticsFieldInAncestors2,
		appPage2
	})
	local v8

	if props.analyticsContext and props.analyticsContext.getCollectionData then
		v8 = props.analyticsContext.getCollectionData()
	end

	local index = props.index
	local itemsPerRow = if v8 then v8.itemsPerRow else nil
	local v10 = if v8 then v8.startRowNumber else nil
	local v11 = calculateRowPositionFields(index, itemsPerRow, v10)

	local v12 = React.useCallback(function(data)
		local v13 = {
			name = appPage.ProfilePlatform,
			detail = data.userId,
			extraProps = {
				profileType = "User",
				profilePeekViewProps = {
					resetPeekView = false,
					source = "PlayerSearch",
					contextualInfoType = data.contextualInfoType,
					contextualInfoDisplay = data.contextualInfoDisplay,
					analyticsProps = analyticsFieldInAncestors and {
						userSearchSessionId = analyticsFieldInAncestors
					} or nil
				}
			}
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v13))
		else
			v5(navigateDown(v13))
		end
	end, { v5, analyticsFieldInAncestors })

	if userId == nil or userId == "" then
		return nil
	end

	local createElement = React.createElement
	local v14 = {
		user = {
			id = userId,
			name = props.name or "",
			displayName = props.displayName or "",
			previousUsernames = props.previousUsernames or {}
		},
		index = props.index or 0,
		size = UDim2.fromScale(1, 1),
		searchParameters = { searchKeyword = v6 },
		luaAppNavigation = { navigateToUserInfo = v12 },
		fireAnalyticsEvent = v7,
		subpage = "UserSearchFeedItem",
		shouldUseCompactTiles = true,
		rowInSort = v11.rowInSort,
		positionInRow = 0,
		feedRowNumber = 0
	}
	local v15 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then v11.positionInRow else nil
	v14.positionInRow = v15
	local v16 = if fFlagLuaAppSearchPeopleUnifiedSchemaFields then v11.rowOnPage else nil
	v14.feedRowNumber = v16
	return createElement(userSearchTile, v14)
end

return React.memo(SduiUserSearchTile)
