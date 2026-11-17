local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local UserSearch = require(parent.UserSearch)
local UserSearchTile = UserSearch.UserSearchTile
local Analytics = UserSearch.Analytics.Analytics
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UnifiedLogging = require(parent.UnifiedLogging)

local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local calculateRowPositionFields = UnifiedLogging.calculateRowPositionFields

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local FFlagLuaAppSearchPeopleUnifiedSchemaFields = SharedFlags.FFlagLuaAppSearchPeopleUnifiedSchemaFields
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function SduiUserSearchTile(props)
	local v = useDispatch()
	local userId = props.userId

	local searchKeyword = findAnalyticsFieldInAncestors("searchQuery", props.analyticsContext) or ""
	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("userSearchSessionId", props.analyticsContext)
	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("collectionId", props.analyticsContext)
	local analyticsFieldInAncestors3 = findAnalyticsFieldInAncestors("collectionPosition", props.analyticsContext)
	local appPage

	if props.sduiContext then
		appPage = props.sduiContext.appPage
	else
		appPage = nil
	end

	local fireAnalyticsEvent = React.useMemo(function()
		return Analytics({
			infoForAllEvents = {
				userSearchSessionId = analyticsFieldInAncestors,
				sortPosition = analyticsFieldInAncestors3,
				sortId = analyticsFieldInAncestors2,
				pageContext = appPage
			}
		}).fireAnalyticsEvent
	end, {
		analyticsFieldInAncestors,
		analyticsFieldInAncestors3,
		analyticsFieldInAncestors2,
		appPage
	})
	local v2

	if props.analyticsContext and props.analyticsContext.getCollectionData then
		v2 = props.analyticsContext.getCollectionData()
	end

	local index = props.index
	local itemsPerRow

	if v2 then
		itemsPerRow = v2.itemsPerRow
	end

	local v3

	if v2 then
		v3 = v2.startRowNumber
	end

	local v4 = calculateRowPositionFields(index, itemsPerRow, v3)

	local navigateToUserInfo = React.useCallback(function(data)
		local v5 = {
			name = AppPage.ProfilePlatform,
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

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			v(NavigateDown(v5))
		end
	end, { v, analyticsFieldInAncestors })

	if userId == nil or userId == "" then
		return nil
	end

	local createElement = React.createElement
	local user = {
		id = userId,
		name = props.name or "",
		displayName = props.displayName or "",
		previousUsernames = not SharedFlags.FFlagUserSearchUsePreviousUsernameMatch and (props.previousUsernames or {}) or nil,
		isPreviousUsernameMatch = 0
	}
	local isPreviousUsernameMatch

	if SharedFlags.FFlagUserSearchUsePreviousUsernameMatch then
		isPreviousUsernameMatch = props.isPreviousUsernameMatch
	end

	user.isPreviousUsernameMatch = isPreviousUsernameMatch
	local v5 = {
		user = user,
		index = props.index or 0,
		size = UDim2.fromScale(1, 1),
		searchParameters = { searchKeyword = searchKeyword },
		luaAppNavigation = { navigateToUserInfo = navigateToUserInfo },
		fireAnalyticsEvent = fireAnalyticsEvent,
		subpage = "UserSearchFeedItem",
		shouldUseCompactTiles = true,
		rowInSort = v4.rowInSort,
		positionInRow = 0,
		feedRowNumber = 0
	}
	local positionInRow

	if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
		positionInRow = v4.positionInRow
	end

	v5.positionInRow = positionInRow
	local feedRowNumber

	if FFlagLuaAppSearchPeopleUnifiedSchemaFields then
		feedRowNumber = v4.rowOnPage
	end

	v5.feedRowNumber = feedRowNumber
	return createElement(UserSearchTile, v5)
end

return React.memo(SduiUserSearchTile)
