local IXPService = game:GetService("IXPService")
local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local RoactAppExperiment = require(parent.RoactAppExperiment)
local Localization = require(parent.Localization)
local UIBlox = require(parent.UIBlox)
local Toast = UIBlox.App.Dialog.Toast

local EventNames = require(ProfileQRCode.Analytics.EventNames)
local ProfileQRCodeTopBar = require(ProfileQRCode.Components.ProfileQRCodeTopBar)
local QRCodeFriendRequestNotification = require(ProfileQRCode.Components.QRCodeFriendRequestNotification)
local FriendAcceptedSnackbar = require(ProfileQRCode.Components.FriendAcceptedSnackbar)
local TextKeys = require(ProfileQRCode.Common.TextKeys)
local useAcceptFriendUrl = require(ProfileQRCode.Networking.useAcceptFriendUrl)
local useAnalytics = require(ProfileQRCode.Analytics.useAnalytics)
local useGetUsersInfoUrl = require(ProfileQRCode.Networking.useGetUsersInfoUrl)
local useLocalization = Localization.Hooks.useLocalization
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local FriendsNetworking = require(parent.FriendsNetworking)
local Images = UIBlox.App.ImageSet.Images

local SignalREvents = require(ProfileQRCode.Common.SignalREvents)

local getFStringProfileQRCodeFriendRequestAlertsExperimentKey = require(ProfileQRCode.Flags.getFStringProfileQRCodeFriendRequestAlertsExperimentKey)

local getFStringProfileQRCodeFriendRequestAlertsLayer = require(ProfileQRCode.Flags.getFStringProfileQRCodeFriendRequestAlertsLayer)
local FFlagQRCodeFriendRequestNotificationV2 = require(ProfileQRCode.Flags.FFlagQRCodeFriendRequestNotificationV2)

local FFlagQRCodeHideBannerForTrustedFriendRequest = require(ProfileQRCode.Flags.FFlagQRCodeHideBannerForTrustedFriendRequest)

local iconsactionsfriendsfriendAdd = Images["icons/actions/friends/friendAdd"]

return (RoactAppExperiment.connectUserLayer({ getFStringProfileQRCodeFriendRequestAlertsLayer() }, function(p, _)
	return {
		profileQRCodeFriendRequestAlertsEnabled = (p[getFStringProfileQRCodeFriendRequestAlertsLayer()] or {})[getFStringProfileQRCodeFriendRequestAlertsExperimentKey()]
	}
end, false)(function(props)
	local v = useLocalization({ friendAdded = TextKeys.FriendAdded })

	local v2 = useAnalytics()
	local profileQRCodeFriendRequestAlertsEnabled = props.profileQRCodeFriendRequestAlertsEnabled

	local robloxEventReceiver = props.robloxEventReceiver
	local state, setState = React.useState(false)
	local state2, setState2, state3, v3, state4, v4, onDismissed

	if FFlagQRCodeFriendRequestNotificationV2 then
		state2, setState2 = React.useState("")
		local setState3
		state3, setState3 = React.useState(false)
		v3 = setState3
		local setState4
		state4, setState4 = React.useState(false)
		v4 = setState4
		onDismissed = React.useCallback(function()
			v4(false)
			v3(false)
		end, {})
	else
		setState2 = nil
		v4 = nil
		v3 = nil
	end

	local v5, v6 = React.useReducer(function(p, p2)
		if p2.type == "addItemToQueue" then
			IXPService:LogUserLayerExposure(getFStringProfileQRCodeFriendRequestAlertsLayer())

			return Cryo.List.join(p, { p2.newUserId })
		end

		if p2.type == "removeItemFromQueue" then
			return Cryo.List.removeIndex(p, 1)
		end

		return p
	end, {})

	local v7 = useLocalUserId()
	local v8 = useGetUsersInfoUrl()
	local v9 = useAcceptFriendUrl()

	local fn = FFlagQRCodeFriendRequestNotificationV2 and function(p)
		local v10 = tostring(p.UserId1)

		if v10 == v7 then
			return (tostring(p.UserId2))
		end

		return v10
	end or nil

	local function friendshipNotificationReceived(p)
		if
			FFlagQRCodeHideBannerForTrustedFriendRequest
			and p.Type == SignalREvents.FriendshipRequested
			and p.EventArgs.TrustedFriendSource == "QrCrossAge"
		then
			return
		end

		if
			p.Type == SignalREvents.FriendshipRequested
			and p.EventArgs.SourceType == FriendsNetworking.Enums.FriendshipOriginSourceType.QrCode.rawValue()
		then
			local newUserId = tostring(p.EventArgs.UserId1)

			if newUserId == v7 then
				newUserId = tostring(p.EventArgs.UserId2)
			end

			v8(newUserId):andThen(function()
				v6({ type = "addItemToQueue", newUserId = newUserId })
			end)
		elseif p.Type == SignalREvents.FriendshipCreated and FFlagQRCodeFriendRequestNotificationV2 then
			local v10 = fn(p.EventArgs)

			v8(v10):andThen(function()
				setState2(v10)
				v4(true)
				v3(p.EventArgs.IsTrustedFriend)
			end)
		end
	end

	React.useEffect(function()
		robloxEventReceiver:observeEvent(SignalREvents.FriendshipNotifications, function(p)
			friendshipNotificationReceived(p)
		end)
	end, { robloxEventReceiver })

	local createElement = React.createElement
	local size

	if FFlagQRCodeFriendRequestNotificationV2 then
		size = UDim2.new(1, 0, 1, 0)
	else
		size = UDim2.new(1, 0, 0, 56)
	end

	local createElement2 = React.createElement
	local v10 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 3 }
	local layout

	if not FFlagQRCodeFriendRequestNotificationV2 then
		layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	end

	local v11 = {
		TopBarWrapper = createElement2("Frame", v10, {
			Layout = layout,
			TopBar = React.createElement(ProfileQRCodeTopBar, {
				appStorageService = props.appStorageService,
				layoutOrder = 1,
				onClose = props.onClose,
				openQrCodeScanner = props.openQrCodeScanner
			})
		}),
		FriendAcceptToastFrame = 0,
		FriendsInviteFrame = 0,
		FriendAcceptedSnackbar = 0
	}
	local friendAcceptToastFrame

	if profileQRCodeFriendRequestAlertsEnabled and state and not FFlagQRCodeFriendRequestNotificationV2 then
		friendAcceptToastFrame = React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 100 },
			{
				FriendAcceptToast = React.createElement(Toast, {
					toastContent = {
						toastTitle = v.friendAdded,
						iconImage = iconsactionsfriendsfriendAdd,
						onDismissed = function()
							setState(false)
						end
					},
					duration = 3,
					show = true
				})
			}
		)
	end

	v11.FriendAcceptToastFrame = friendAcceptToastFrame
	local friendsInviteFrame

	if profileQRCodeFriendRequestAlertsEnabled and #v5 > 0 and not state then
		friendsInviteFrame = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 24),
				Size = UDim2.new(1, 0, 1, 0),
				ZIndex = 100
			},
			{
				Padding = React.createElement("UIPadding", {
					PaddingRight = UDim.new(0, 28),
					PaddingLeft = UDim.new(0, 28)
				}),
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				FriendsInvite = React.createElement(QRCodeFriendRequestNotification, {
					notificationQueueSize = #v5,
					onAccept = function(p)
						v9(v7, p):andThen(function()
							v6({ type = "removeItemFromQueue", newUserId = "0" })

							if not FFlagQRCodeFriendRequestNotificationV2 then
								setState(true)
							end
						end):catch(function() end)
						v2.fireEvent(EventNames.QRPageFriendRequestBannerAccepted, {
							qrCodeBannerQueueSize = #v5
						})
					end,
					onClose = function()
						v6({ type = "removeItemFromQueue", newUserId = "0" })
						v2.fireEvent(EventNames.QRPageFriendRequestBannerDismissed, {
							qrCodeBannerQueueSize = #v5
						})
					end,
					userId = tostring(v5[1])
				})
			}
		)
	end

	v11.FriendsInviteFrame = friendsInviteFrame
	local friendAcceptedSnackbar

	if state4 and FFlagQRCodeFriendRequestNotificationV2 then
		friendAcceptedSnackbar = React.createElement(FriendAcceptedSnackbar, {
			acceptedFriendUserId = state2,
			newFriendIsTrusted = state3,
			onDismissed = onDismissed
		})
	end

	v11.FriendAcceptedSnackbar = friendAcceptedSnackbar
	return createElement("Frame", {
		Size = size,
		BackgroundTransparency = 1,
		ZIndex = 3,
		LayoutOrder = 1
	}, v11)
end))
