local SocialContextToasts = script:FindFirstAncestor("SocialContextToasts")
local parent = SocialContextToasts.Parent
local ToastWrapper = require(SocialContextToasts.ToastWrapper)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local React = require(parent.React)
local ToastTypes = require(SocialContextToasts.Enums.ToastTypes)
local UIBlox = require(parent.UIBlox)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Cryo = require(parent.Cryo)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagEnableReferredPlayerJoinRemoteEvent = SharedFlags.GetFFlagEnableReferredPlayerJoinRemoteEvent

local function ToastRoot(p)
	local v = useSelector(function(p2)
		return p2.ToastContent
	end)

	local joined = Cryo.Dictionary.join(p.analyticsProps, { toastType = v.toastType })

	if v.toastType == ToastTypes.None then
		return nil
	end

	if v.toastType == ToastTypes.YouJoinedFriends then
		local v2 = nil
		local userList = v.userList
		local toastStrings

		if #userList == 1 then
			toastStrings = {
				label = {
					"Feature.SocialContextToast.Message.YouJoinedOneFriend",
					FRIEND_NAME = userList[1].name
				}
			}
		elseif #userList == 2 then
			toastStrings = {
				label = {
					"Feature.SocialContextToast.Message.YouJoinedTwoFriends",
					FRIEND_NAME_ONE = userList[1].name,
					FRIEND_NAME_TWO = userList[2].name
				}
			}
		else
			toastStrings = #userList > 2 and {
				label = {
					"Feature.SocialContextToast.Message.YouJoinedManyFriends",
					FRIEND_NAME = userList[1].name,
					FRIEND_COUNT = #userList - 1
				}
			} or v2
		end

		local userIds = {}

		for k, _ in userList do
			table.insert(userIds, userList[k].userId)
		end

		return React.createElement(ToastWrapper, {
			toastStrings = toastStrings,
			userIdList = userIds,
			analyticsProps = joined
		})
	end

	if v.toastType == ToastTypes.FriendJoinedYou then
		return React.createElement(ToastWrapper, {
			toastStrings = {
				label = {
					"Feature.SocialContextToast.Message.FriendJoinedYou",
					FRIEND_NAME = v.joinerName
				}
			},
			userIdList = { v.joinerUserId },
			analyticsProps = joined
		})
	end

	if v.toastType == ToastTypes.FriendInNonRootPlace then
		return React.createElement(ToastWrapper, {
			toastStrings = {
				label = {
					"Feature.SocialContextToast.Message.FriendInNonRootPlace",
					FRIEND_NAME = v.joinerName
				}
			},
			userIdList = { v.joinerUserId },
			analyticsProps = joined
		})
	end

	if v.toastType == ToastTypes.FollowYourFriend then
		return React.createElement(ToastWrapper, {
			toastStrings = {
				label = {
					"Feature.SocialContextToast.Message.FollowedFriendInOtherUniverse",
					FRIEND_NAME = v.joinerName,
					EXPERIENCE_NAME = v.experienceName
				},
				button = "Feature.SocialContextToast.Action.JoinFriend"
			},
			userIdList = { v.joinerUserId },
			onActivated = v.onActivated,
			buttonType = ButtonType.PrimaryContextual,
			analyticsProps = joined
		})
	end

	if v.toastType == ToastTypes.InviteBack then
		return React.createElement(ToastWrapper, {
			toastStrings = {
				label = {
					"Feature.SocialContextToast.Message.FollowedFriendNotInGame",
					FRIEND_NAME = v.joinerName
				},
				button = "Feature.SocialContextToast.Action.InviteBack"
			},
			userIdList = { v.joinerUserId },
			onActivated = v.onActivated,
			areUsersActive = false,
			analyticsProps = joined
		})
	end

	if v.toastType == ToastTypes.InviteSuccess then
		return React.createElement(ToastWrapper, {
			toastStrings = { label = "Feature.SocialContextToast.Message.InvitationConfirmation" },
			analyticsProps = joined
		})
	end

	if v.toastType == ToastTypes.InviteFailure then
		return React.createElement(ToastWrapper, {
			toastStrings = { label = "Feature.SocialContextToast.Message.InvitationFailure" },
			analyticsProps = joined
		})
	end

	if GetFFlagEnableReferredPlayerJoinRemoteEvent() and v.toastType == ToastTypes.InviteeJoinedYou then
		return React.createElement(ToastWrapper, {
			toastStrings = {
				label = {
					"Feature.SocialContextToast.Message.InviteeJoinedYou",
					INVITEE_NAME = v.joinerName
				}
			},
			userIdList = { v.joinerUserId },
			analyticsProps = joined
		})
	end

	return nil
end

return ToastRoot
