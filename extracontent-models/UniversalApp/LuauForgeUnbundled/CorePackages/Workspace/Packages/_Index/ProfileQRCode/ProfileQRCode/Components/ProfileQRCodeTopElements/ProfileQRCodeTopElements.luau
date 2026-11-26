local IXPService = game:GetService("IXPService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RoactAppExperiment")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Localization")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/UIBlox")
local toast = UIBlox.App.Dialog.Toast

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/EventNames")
local ProfileQRCodeTopBar = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Components/ProfileQRCodeTopBar")
local QRCodeFriendRequestNotification = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Components/QRCodeFriendRequestNotification")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Components/FriendAcceptedSnackbar")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Common/TextKeys")
local useAcceptFriendUrl = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/useAcceptFriendUrl")
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/useAnalytics")
local useGetUsersInfoUrl = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/useGetUsersInfoUrl")
local useLocalization = Localization.Hooks.useLocalization
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RobloxAppHooks").useLocalUserId
local NetworkingFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/NetworkingFriends")
local images = UIBlox.App.ImageSet.Images

local SignalREvents = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Common/SignalREvents")

local getFStringProfileQRCodeFriendRequestAlertsExperimentKey = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Flags/getFStringProfileQRCodeFriendRequestAlertsExperimentKey")

local getFStringProfileQRCodeFriendRequestAlertsLayer = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Flags/getFStringProfileQRCodeFriendRequestAlertsLayer")
local FFlagQRCodeFriendRequestNotificationV2 = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Flags/FFlagQRCodeFriendRequestNotificationV2")

local FFlagQRCodeHideBannerForTrustedFriendRequest = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Flags/FFlagQRCodeHideBannerForTrustedFriendRequest")

local iconsactionsfriendsfriendAdd = images["icons/actions/friends/friendAdd"]

return (RoactAppExperiment.connectUserLayer({ getFStringProfileQRCodeFriendRequestAlertsLayer() }, function(p2, p3)
	return {
		profileQRCodeFriendRequestAlertsEnabled = (p2[getFStringProfileQRCodeFriendRequestAlertsLayer()] or {})[getFStringProfileQRCodeFriendRequestAlertsExperimentKey()]
	}
end, false)(function(props)
	local v5 = useLocalization({ friendAdded = TextKeys.FriendAdded })

	local v6 = useAnalytics()
	local profileQRCodeFriendRequestAlertsEnabled = props.profileQRCodeFriendRequestAlertsEnabled

	local robloxEventReceiver = props.robloxEventReceiver
	local state, setState = React.useState(false)
	local state2, setState2, state3, v7, state4, v8, v9

	if FFlagQRCodeFriendRequestNotificationV2 then
		state2, setState2 = React.useState("")
		local setState3
		state3, setState3 = React.useState(false)
		v7 = setState3
		local setState4
		state4, setState4 = React.useState(false)
		v8 = setState4
		v9 = React.useCallback(function()
			v8(false)
			v7(false)
		end, {})
	else
		setState2 = nil
		v8 = nil
		v7 = nil
	end

	local v10, v11 = React.useReducer(function(p2, p3)
		if p3.type == "addItemToQueue" then
			IXPService:LogUserLayerExposure(getFStringProfileQRCodeFriendRequestAlertsLayer())

			return Cryo.List.join(p2, { p3.newUserId })
		end

		if p3.type == "removeItemFromQueue" then
			return Cryo.List.removeIndex(p2, 1)
		end

		return p2
	end, {})

	local v12 = useLocalUserId()
	local v13 = useGetUsersInfoUrl()
	local v14 = useAcceptFriendUrl()

	local fn = FFlagQRCodeFriendRequestNotificationV2 and function(p2)
		local v15 = tostring(p2.UserId1)

		if v15 == v12 then
			v15 = tostring(p2.UserId2)
		end

		return v15
	end or nil

	local function friendshipNotificationReceived(p2)
		if
			FFlagQRCodeHideBannerForTrustedFriendRequest
			and p2.Type == SignalREvents.FriendshipRequested
			and p2.EventArgs.TrustedFriendSource == "QrCrossAge"
		then
			return
		end

		if
			p2.Type == SignalREvents.FriendshipRequested
			and p2.EventArgs.SourceType == NetworkingFriends.Enums.FriendshipOriginSourceType.QrCode.rawValue()
		then
			local v15 = tostring(p2.EventArgs.UserId1)

			if v15 == v12 then
				v15 = tostring(p2.EventArgs.UserId2)
			end

			v13(v15):andThen(function()
				v11({ type = "addItemToQueue", newUserId = v15 })
			end)
		elseif p2.Type == SignalREvents.FriendshipCreated and FFlagQRCodeFriendRequestNotificationV2 then
			local v15 = fn(p2.EventArgs)

			v13(v15):andThen(function()
				setState2(v15)
				v8(true)
				v7(p2.EventArgs.IsTrustedFriend)
			end)
		end
	end

	React.useEffect(function()
		robloxEventReceiver:observeEvent(SignalREvents.FriendshipNotifications, function(p2)
			friendshipNotificationReceived(p2)
		end)
	end, { robloxEventReceiver })

	local createElement = React.createElement

	local v17 = if FFlagQRCodeFriendRequestNotificationV2 then UDim2.new(1, 0, 1, 0) else UDim2.new(1, 0, 0, 56)

	local createElement2 = React.createElement
	local v20 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ZIndex = 3 }

	local v22 = if not FFlagQRCodeFriendRequestNotificationV2 then React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder
	}) else nil
	local v18 = {
		TopBarWrapper = createElement2("Frame", v20, {
			Layout = v22,
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
	local v23

	if profileQRCodeFriendRequestAlertsEnabled and state and not FFlagQRCodeFriendRequestNotificationV2 then
		v23 = React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 100 },
			{
				FriendAcceptToast = React.createElement(toast, {
					toastContent = {
						toastTitle = v5.friendAdded,
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

	v18.FriendAcceptToastFrame = v23
	local v24

	if profileQRCodeFriendRequestAlertsEnabled and #v10 > 0 and not state then
		v24 = React.createElement(
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
					notificationQueueSize = #v10,
					onAccept = function(p2)
						v14(v12, p2):andThen(function()
							v11({ type = "removeItemFromQueue", newUserId = "0" })

							if not FFlagQRCodeFriendRequestNotificationV2 then
								setState(true)
							end
						end):catch(function() end)
						v6.fireEvent(EventNames.QRPageFriendRequestBannerAccepted, {
							qrCodeBannerQueueSize = #v10
						})
					end,
					onClose = function()
						v11({ type = "removeItemFromQueue", newUserId = "0" })
						v6.fireEvent(EventNames.QRPageFriendRequestBannerDismissed, {
							qrCodeBannerQueueSize = #v10
						})
					end,
					userId = tostring(v10[1])
				})
			}
		)
	end

	v18.FriendsInviteFrame = v24

	local v25 = if state4 and FFlagQRCodeFriendRequestNotificationV2 then React.createElement(module9, {
		acceptedFriendUserId = state2,
		newFriendIsTrusted = state3,
		onDismissed = v9
	}) else nil
	v18.FriendAcceptedSnackbar = v25
	return createElement(
		"Frame",
		{ Size = v17, BackgroundTransparency = 1, ZIndex = 3, LayoutOrder = 1 },
		v18
	)
end))
