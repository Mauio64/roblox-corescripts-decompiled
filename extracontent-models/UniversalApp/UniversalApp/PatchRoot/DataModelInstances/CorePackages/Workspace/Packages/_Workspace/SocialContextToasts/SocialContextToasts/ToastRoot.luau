local SocialContextToasts = script:FindFirstAncestor("SocialContextToasts")
local SocialContextToastsParent = SocialContextToasts.Parent
local ToastWrapper = require(SocialContextToasts.ToastWrapper)
local useSelector = require(SocialContextToastsParent.RoactUtils).Hooks.RoactRodux.useSelector
local React = require(SocialContextToastsParent.React)
local ToastTypes = require(SocialContextToasts.Enums.ToastTypes)
local ButtonType = require(SocialContextToastsParent.UIBlox).App.Button.Enum.ButtonType
local Cryo = require(SocialContextToastsParent.Cryo)
local GetFFlagSocialContextToastEventStream = require(SocialContextToastsParent.SharedFlags).GetFFlagSocialContextToastEventStream
local GetFFlagEnableReferredPlayerJoinRemoteEvent = require(SocialContextToastsParent.SharedFlags).GetFFlagEnableReferredPlayerJoinRemoteEvent

local function ToastRoot(p1) -- line: 44
	-- upvalues: useSelector (copy), GetFFlagSocialContextToastEventStream (copy), Cryo (copy), ToastTypes (copy), React (copy), ToastWrapper (copy), ButtonType (copy), GetFFlagEnableReferredPlayerJoinRemoteEvent (copy)
	local v13 = useSelector(function(p2) -- line: 45
		return p2.ToastContent
	end)
	local v14 = if not GetFFlagSocialContextToastEventStream() then nil else Cryo.Dictionary.join(p1.analyticsProps, {
		toastType = v13.toastType
	})

	if v13.toastType == ToastTypes.None then
		return nil
	end

	if v13.toastType == ToastTypes.YouJoinedFriends then
		local t1 = nil
		local userList = v13.userList

		if #userList == 1 then
			t1 = {
				label = {
					"Feature.SocialContextToast.Message.YouJoinedOneFriend",
					FRIEND_NAME = userList[1].name
				}
			}
		elseif #userList == 2 then
			t1 = {
				label = {
					"Feature.SocialContextToast.Message.YouJoinedTwoFriends",
					FRIEND_NAME_ONE = userList[1].name,
					FRIEND_NAME_TWO = userList[2].name
				}
			}
		elseif #userList > 2 then
			t1 = {
				label = {
					"Feature.SocialContextToast.Message.YouJoinedManyFriends",
					FRIEND_NAME = userList[1].name,
					FRIEND_COUNT = #userList - 1
				}
			}
		end

		local t2 = {}

		for v18, _ in userList do
			table.insert(t2, userList[v18].userId)
		end

		return React.createElement(ToastWrapper, {
			toastStrings = t1,
			userIdList = t2,
			analyticsProps = v14
		})
	end

	if v13.toastType == ToastTypes.FriendJoinedYou then
		return React.createElement(ToastWrapper, {
			toastStrings = {
				label = {
					"Feature.SocialContextToast.Message.FriendJoinedYou",
					FRIEND_NAME = v13.joinerName
				}
			},
			userIdList = { v13.joinerUserId },
			analyticsProps = v14
		})
	end

	if v13.toastType == ToastTypes.FriendInNonRootPlace then
		return React.createElement(ToastWrapper, {
			toastStrings = {
				label = {
					"Feature.SocialContextToast.Message.FriendInNonRootPlace",
					FRIEND_NAME = v13.joinerName
				}
			},
			userIdList = { v13.joinerUserId },
			analyticsProps = v14
		})
	end

	if v13.toastType == ToastTypes.FollowYourFriend then
		return React.createElement(ToastWrapper, {
			toastStrings = {
				button = "Feature.SocialContextToast.Action.JoinFriend",
				label = {
					"Feature.SocialContextToast.Message.FollowedFriendInOtherUniverse",
					FRIEND_NAME = v13.joinerName,
					EXPERIENCE_NAME = v13.experienceName
				}
			},
			userIdList = { v13.joinerUserId },
			onActivated = v13.onActivated,
			buttonType = ButtonType.PrimaryContextual,
			analyticsProps = v14
		})
	end

	if v13.toastType == ToastTypes.InviteBack then
		return React.createElement(ToastWrapper, {
			areUsersActive = false,
			toastStrings = {
				button = "Feature.SocialContextToast.Action.InviteBack",
				label = {
					"Feature.SocialContextToast.Message.FollowedFriendNotInGame",
					FRIEND_NAME = v13.joinerName
				}
			},
			userIdList = { v13.joinerUserId },
			onActivated = v13.onActivated,
			analyticsProps = v14
		})
	end

	if v13.toastType == ToastTypes.InviteSuccess then
		return React.createElement(ToastWrapper, {
			toastStrings = {
				label = "Feature.SocialContextToast.Message.InvitationConfirmation"
			},
			analyticsProps = v14
		})
	end

	if v13.toastType == ToastTypes.InviteFailure then
		return React.createElement(ToastWrapper, {
			toastStrings = {
				label = "Feature.SocialContextToast.Message.InvitationFailure"
			},
			analyticsProps = v14
		})
	end

	if GetFFlagEnableReferredPlayerJoinRemoteEvent() and v13.toastType == ToastTypes.InviteeJoinedYou then
		return React.createElement(ToastWrapper, {
			toastStrings = {
				label = {
					"Feature.SocialContextToast.Message.InviteeJoinedYou",
					INVITEE_NAME = v13.joinerName
				}
			},
			userIdList = { v13.joinerUserId },
			analyticsProps = v14
		})
	end

	return nil
end

return ToastRoot
