local SocialProof = script:FindFirstAncestor("SocialProof")
local SocialProofParent = SocialProof.Parent
local React = require(SocialProofParent.React)
local useEntityConnectionsPagination = require(SocialProof.Hooks.useEntityConnectionsPagination)
local UserListViewAdaptor = require(SocialProofParent.UserList).Components.UserListViewAdaptor
local FFlagUserListUseSheet = require(SocialProofParent.SharedFlags).FFlagUserListUseSheet
local UserListSheet = require(script.Parent.UserListSheet)
local Enums = require(SocialProof.Common.Enums)
local useLocalization = require(SocialProofParent.Localization).Hooks.useLocalization
local useNavigationProps = require(SocialProofParent.RobloxAppNavigation).useNavigationProps
local AppPage = require(SocialProofParent.RobloxAppEnums).AppPage
local NavigateDown = require(SocialProofParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(SocialProofParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v14 = if not FFlagSignalsNavP3Dispatch then nil else require(SocialProofParent.RobloxAppNavigation).NavigationCommands
local useDispatch = require(SocialProofParent.RoactUtils).Hooks.RoactRodux.useDispatch
local Constants = require(SocialProof.Common.Constants)
local FFlagConnectionsToFriendsRename = require(SocialProofParent.SharedFlags).FFlagConnectionsToFriendsRename
local t1 = {
	position = UDim2.fromScale(0.6, 0),
	size = UDim2.fromScale(0.4, 1),
	anchorPoint = Vector2.new(0, 0)
}
local t2 = {
	position = UDim2.fromScale(0.5, 0),
	size = UDim2.new(0, 640, 1, 0),
	anchorPoint = Vector2.new(0.5, 0)
}

local function FriendsOwnedUserList(_) -- line: 39
	-- upvalues: useDispatch (copy), useNavigationProps (copy), useEntityConnectionsPagination (copy), Enums (copy), React (copy), t2 (copy), t1 (copy), AppPage (copy), Constants (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), NavigateDown (copy), useLocalization (copy), FFlagConnectionsToFriendsRename (copy), FFlagUserListUseSheet (copy), UserListSheet (copy), UserListViewAdaptor (copy)
	local v22 = useDispatch()
	local v23 = useNavigationProps(function(_, p3) -- line: 41
		return {
			entityId = p3.entityId,
			entityType = p3.entityType,
			source = p3.source
		}
	end)
	local v24 = useEntityConnectionsPagination({
		initialCursor = nil,
		entityId = v23.entityId,
		entityType = v23.entityType,
		connectionType = Enums.ConnectionType.Friend
	})
	local v25 = React.useMemo(function() -- line: 57
		-- upvalues: v23 (copy), t2 (copy), t1 (copy)
		if v23.source == "profile" then
			return t2
		end

		return t1
	end, { v23.source })
	local v26 = React.useCallback(function() -- line: 66
		-- upvalues: v24 (copy)
		if v24.hasMore and not v24.isLoading then
			v24.fetchPage()
		end
	end, {
		v24.hasMore,
		v24.isLoading,
		v24.fetchPage
	})
	local v27 = React.useCallback(function(s1: string) -- line: 73
		-- upvalues: AppPage (copy), Constants (copy), FFlagSignalsNavP3Dispatch (copy), v14 (copy), v22 (copy), NavigateDown (copy)
		local t3 = {
			name = AppPage.ProfilePlatform,
			detail = s1,
			extraProps = {
				profileType = Constants.PROFILE_TYPE,
				source = Constants.ITEM_DETAILS_PAGE_SOURCE
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v14.down(v14.fromLegacyPage(t3))

			return
		end

		v22(NavigateDown(t3))
	end, { v22 })
	local v28 = useLocalization({
		connectionsOwn = {
			not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionsOwn" or "Feature.Friends.Label.FriendsOwn",
			numberOfConnections = v24.totalConnections
		},
		singleConnectionOwns = not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionOwns" or "Feature.Friends.Label.FriendOwns"
	})
	local v29 = if v24.totalConnections ~= 1 then v28.connectionsOwn else v28.singleConnectionOwns

	if v24.totalConnections == 0 then
		return nil
	end

	if FFlagUserListUseSheet then
		return React.createElement(UserListSheet, {
			users = v24.userIds,
			title = v29,
			onLoadMore = v26,
			onUserSelected = v27,
			hasMore = v24.hasMore
		})
	end

	return React.createElement(UserListViewAdaptor, {
		users = v24.userIds,
		title = v29,
		totalCount = v24.totalConnections,
		onLoadMore = v26,
		onUserSelected = v27,
		hasMore = v24.hasMore,
		wideModePeekViewLayout = v25
	})
end

return FriendsOwnedUserList
