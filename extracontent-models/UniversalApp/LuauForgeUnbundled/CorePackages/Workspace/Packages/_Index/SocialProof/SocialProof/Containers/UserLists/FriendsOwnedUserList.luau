local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/React")
local useEntityConnectionsPagination = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Hooks/useEntityConnectionsPagination")
local userListViewAdaptor = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/UserList").Components.UserListViewAdaptor
local fFlagUserListUseSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/SharedFlags").FFlagUserListUseSheet
local UserListSheet = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Containers/UserLists/UserListSheet")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Common/Enums")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/Localization").Hooks.useLocalization
local useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RobloxAppNavigation").useNavigationProps
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/NavigationRodux").Thunks.NavigateDown
local navigateBack = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/NavigationRodux").Thunks.NavigateBack
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RobloxAppNavigation").NavigationCommands else nil

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RoactUtils").Hooks.RoactRodux.useDispatch
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Common/Constants")

local v5 = {
	position = UDim2.fromScale(0.6, 0),
	size = UDim2.fromScale(0.4, 1),
	anchorPoint = Vector2.new(0, 0)
}

local v6 = {
	position = UDim2.fromScale(0.5, 0),
	size = UDim2.new(0, 640, 1, 0),
	anchorPoint = Vector2.new(0.5, 0)
}

local function FriendsOwnedUserList(p2)
	local v7 = useDispatch()
	local v8 = useNavigationProps(function(p3, data)
		return {
			entityId = data.entityId,
			entityType = data.entityType,
			source = data.source
		}
	end)

	local v9 = useEntityConnectionsPagination({
		entityId = v8.entityId,
		entityType = v8.entityType,
		connectionType = Enums.ConnectionType.Friend,
		initialCursor = nil
	})

	local v10 = React.useMemo(function()
		if v8.source == "profile" then
			return v6
		end

		return v5
	end, { v8.source })

	local v11 = React.useCallback(function()
		if v9.hasMore and not v9.isLoading then
			v9.fetchPage()
		end
	end, { v9.hasMore, v9.isLoading, v9.fetchPage })

	local v12 = React.useCallback(function(p3)
		local v13 = {
			name = appPage.ProfilePlatform,
			detail = p3,
			extraProps = {
				profileType = Constants.PROFILE_TYPE,
				source = Constants.ITEM_DETAILS_PAGE_SOURCE
			}
		}

		if fFlagUserListUseSheet then
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back(true)
				navigationCommands.down(navigationCommands.fromLegacyPage(v13), true)
			else
				v7(navigateBack(true))
				v7(navigateDown(v13, true))
			end
		elseif fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v13))
		else
			v7(navigateDown(v13))
		end
	end, { v7 })

	local v13 = useLocalization({
		connectionsOwn = {
			"Feature.Friends.Label.FriendsOwn",
			numberOfConnections = v9.totalConnections
		},
		singleConnectionOwns = "Feature.Friends.Label.FriendOwns"
	})

	local v14 = if v9.totalConnections == 1 then v13.singleConnectionOwns else v13.connectionsOwn

	if v9.totalConnections == 0 then
		return nil
	end

	if fFlagUserListUseSheet then
		return React.createElement(UserListSheet, {
			users = v9.userIds,
			title = v14,
			onLoadMore = v11,
			onUserSelected = v12,
			hasMore = v9.hasMore
		})
	end

	return React.createElement(userListViewAdaptor, {
		users = v9.userIds,
		title = v14,
		totalCount = v9.totalConnections,
		onLoadMore = v11,
		onUserSelected = v12,
		hasMore = v9.hasMore,
		wideModePeekViewLayout = v10
	})
end

return FriendsOwnedUserList
