local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local SetNicknameModal = require(script.Parent.SetNicknameModal)
local React = require(ParentParentParent.React)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local FriendsNetworking = require(ParentParent.Networking.FriendsNetworking)
local UserProfiles = require(ParentParentParent.UserProfiles)
local useScreenSize = RobloxAppHooks.useScreenSize
local useDispatch = require(ParentParentParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalUserId = require(ParentParentParent.RobloxAppHooks).useLocalUserId
local RobloxAppNavigation = require(ParentParentParent.RobloxAppNavigation)
local useNavigation = require(ParentParentParent.Navigation).useNavigation
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local userProfilesDisplayNameAndUsernameByUserIds = UserProfiles.Queries.userProfilesDisplayNameAndUsernameByUserIds

return function() -- line: 30
	-- upvalues: useScreenSize (copy), useDispatch (copy), useLocalUserId (copy), useNavigation (copy), RobloxAppNavigation (copy), useUserProfilesFetch (copy), userProfilesDisplayNameAndUsernameByUserIds (copy), UserProfiles (copy), FriendsNetworking (copy), React (copy), SetNicknameModal (copy)
	local v15 = useScreenSize()
	local v16 = useDispatch()
	local v17 = useLocalUserId()
	local v18 = useNavigation()
	local friendRequestParams = RobloxAppNavigation.useNavigationProps(function(_, p2) -- line: 36
		return {
			friendRequestParams = p2.friendRequestParams
		}
	end).friendRequestParams
	local v20 = useUserProfilesFetch({
		userIds = { friendRequestParams.targetUserId },
		query = userProfilesDisplayNameAndUsernameByUserIds
	})
	local v21 = if not friendRequestParams or (not v20 or not v20.data) then nil else UserProfiles.Selectors.getDisplayNameFromId(v20.data, friendRequestParams.targetUserId)
	local v22, v23 = React.useState(false)
	local v24, v25 = React.useState(false)

	return React.createElement(SetNicknameModal, {
		friendRequestSource = friendRequestParams.source,
		recipientDisplayName = v21,
		screenSize = v15,
		navigateBack = v18.goBack,
		sendFriendRequest = function() -- line: 68
			-- upvalues: v17 (copy), friendRequestParams (copy), v16 (copy), FriendsNetworking (copy)
			local t1 = {
				currentUserId = v17,
				targetUserId = friendRequestParams.targetUserId,
				friendshipOriginSourceType = friendRequestParams.source
			}

			return v16(FriendsNetworking.RequestFriendshipFromUserId.API(t1))
		end,
		sendFriendRequestWithNickname = function(p3) -- line: 77
			-- upvalues: v17 (copy), friendRequestParams (copy), v16 (copy), FriendsNetworking (copy)
			local t2 = {
				currentUserId = v17,
				targetUserId = friendRequestParams.targetUserId,
				friendshipOriginSourceType = friendRequestParams.source,
				senderNickname = p3
			}

			return v16(FriendsNetworking.RequestFriendshipFromUserId.API(t2))
		end,
		validateNickname = function(p4) -- line: 57
			-- upvalues: v17 (copy), v16 (copy), FriendsNetworking (copy)
			local t3 = {
				senderNickname = p4,
				currentUserId = v17
			}

			return v16(FriendsNetworking.ValidateFriendRequestNickname.API(t3))
		end,
		onTextInput = v22,
		setOnTextInput = v23,
		isSaveButtonEnabled = v24,
		setSaveButtonEnabled = v25,
		source = friendRequestParams.source
	})
end
