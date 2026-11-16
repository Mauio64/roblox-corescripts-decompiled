local SocialProof = script:FindFirstAncestor("SocialProof")
local parent = SocialProof.Parent

local React = require(parent.React)
local useEntityConnectionsPagination = require(SocialProof.Hooks.useEntityConnectionsPagination)
local UserList = require(parent.UserList)
local UserListViewAdaptor = UserList.Components.UserListViewAdaptor
local SharedFlags = require(parent.SharedFlags)
local FFlagUserListUseSheet = SharedFlags.FFlagUserListUseSheet
local UserListSheet = require(script.Parent.UserListSheet)
local Enums = require(SocialProof.Common.Enums)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local useNavigationProps = RobloxAppNavigation.useNavigationProps
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local NavigationRodux2 = require(parent.NavigationRodux)
local NavigateBack = NavigationRodux2.Thunks.NavigateBack
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags2.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation2 = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation2.NavigationCommands
else
	navigationCommands = nil
end

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Constants = require(SocialProof.Common.Constants)

local v = {
	position = UDim2.fromScale(0.6, 0),
	size = UDim2.fromScale(0.4, 1),
	anchorPoint = Vector2.new(0, 0)
}

local v2 = {
	position = UDim2.fromScale(0.5, 0),
	size = UDim2.new(0, 640, 1, 0),
	anchorPoint = Vector2.new(0.5, 0)
}

local function FriendsOwnedUserList(_)
	local v3 = useDispatch()
	local v4 = useNavigationProps(function(_, data)
		return { entityId = data.entityId, entityType = data.entityType, source = data.source }
	end)

	local v5 = useEntityConnectionsPagination({
		entityId = v4.entityId,
		entityType = v4.entityType,
		connectionType = Enums.ConnectionType.Friend,
		initialCursor = nil
	})

	local wideModePeekViewLayout = React.useMemo(function()
		return if v4.source == "profile" then v2 else v
	end, { v4.source })

	local onLoadMore = React.useCallback(function()
		if v5.hasMore and not v5.isLoading then
			v5.fetchPage()
		end
	end, { v5.hasMore, v5.isLoading, v5.fetchPage })

	local onUserSelected = React.useCallback(function(detail: string)
		local v6 = {
			name = AppPage.ProfilePlatform,
			detail = detail,
			extraProps = {
				profileType = Constants.PROFILE_TYPE,
				source = Constants.ITEM_DETAILS_PAGE_SOURCE
			}
		}

		if FFlagUserListUseSheet then
			if FFlagSignalsNavP3Dispatch then
				navigationCommands.back(true)
				navigationCommands.down(navigationCommands.fromLegacyPage(v6), true)
			else
				v3(NavigateBack(true))
				v3(NavigateDown(v6, true))
			end
		elseif FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v6))
		else
			v3(NavigateDown(v6))
		end
	end, { v3 })

	local v6 = useLocalization({
		connectionsOwn = {
			"Feature.Friends.Label.FriendsOwn",
			numberOfConnections = v5.totalConnections
		},
		singleConnectionOwns = "Feature.Friends.Label.FriendOwns"
	})
	local title

	if v5.totalConnections == 1 then
		title = v6.singleConnectionOwns
	else
		title = v6.connectionsOwn
	end

	if v5.totalConnections == 0 then
		return nil
	end

	if FFlagUserListUseSheet then
		return React.createElement(UserListSheet, {
			users = v5.userIds,
			title = title,
			onLoadMore = onLoadMore,
			onUserSelected = onUserSelected,
			hasMore = v5.hasMore
		})
	end

	return React.createElement(UserListViewAdaptor, {
		users = v5.userIds,
		title = title,
		totalCount = v5.totalConnections,
		onLoadMore = onLoadMore,
		onUserSelected = onUserSelected,
		hasMore = v5.hasMore,
		wideModePeekViewLayout = wideModePeekViewLayout
	})
end

return FriendsOwnedUserList
