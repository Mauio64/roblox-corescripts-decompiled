local IXPService = game:GetService("IXPService")
local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local Cryo = require(ProfileQRCodeParent.Cryo)
local React = require(ProfileQRCodeParent.React)
local RoactAppExperiment = require(ProfileQRCodeParent.RoactAppExperiment)
local Localization = require(ProfileQRCodeParent.Localization)
local UIBlox = require(ProfileQRCodeParent.UIBlox)
local SharedFlags = require(ProfileQRCodeParent.SharedFlags)
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
local useLocalUserId = require(ProfileQRCodeParent.RobloxAppHooks).useLocalUserId
local FriendsNetworking = require(ProfileQRCodeParent.FriendsNetworking)
local Images = UIBlox.App.ImageSet.Images
local SignalREvents = require(ProfileQRCode.Common.SignalREvents)
local getFStringProfileQRCodeFriendRequestAlertsExperimentKey = require(ProfileQRCode.Flags.getFStringProfileQRCodeFriendRequestAlertsExperimentKey)
local getFStringProfileQRCodeFriendRequestAlertsLayer = require(ProfileQRCode.Flags.getFStringProfileQRCodeFriendRequestAlertsLayer)
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagQRCodeFriendRequestNotificationV2 = require(ProfileQRCode.Flags.FFlagQRCodeFriendRequestNotificationV2)
local v28 = Images["icons/actions/friends/friendAdd"]

return (RoactAppExperiment.connectUserLayer({ getFStringProfileQRCodeFriendRequestAlertsLayer() }, function(p1, _) -- line: 246
	-- upvalues: getFStringProfileQRCodeFriendRequestAlertsLayer (copy), getFStringProfileQRCodeFriendRequestAlertsExperimentKey (copy)
	return {
		profileQRCodeFriendRequestAlertsEnabled = (p1[getFStringProfileQRCodeFriendRequestAlertsLayer()] or {})[getFStringProfileQRCodeFriendRequestAlertsExperimentKey()]
	}
end, false)(function(t1: {[any]: any}) -- line: 53
	-- upvalues: useLocalization (copy), FFlagConnectionsToFriendsRename (copy), TextKeys (copy), useAnalytics (copy), React (copy), FFlagQRCodeFriendRequestNotificationV2 (copy), IXPService (copy), getFStringProfileQRCodeFriendRequestAlertsLayer (copy), Cryo (copy), useLocalUserId (copy), useGetUsersInfoUrl (copy), useAcceptFriendUrl (copy), SignalREvents (copy), FriendsNetworking (copy), ProfileQRCodeTopBar (copy), Toast (copy), v28 (copy), QRCodeFriendRequestNotification (copy), EventNames (copy), FriendAcceptedSnackbar (copy)
	local v30 = useLocalization({
		friendAdded = if not FFlagConnectionsToFriendsRename then TextKeys.ConnectionAdded else TextKeys.FriendAdded
	})
	local v31 = useAnalytics()
	local profileQRCodeFriendRequestAlertsEnabled = t1.profileQRCodeFriendRequestAlertsEnabled
	local robloxEventReceiver = t1.robloxEventReceiver
	local v34, v35 = React.useState(false)
	local v36 = nil
	local u37 = nil
	local v38 = nil
	local u39 = nil
	local v40 = nil
	local u41 = nil
	local v42 = nil

	if FFlagQRCodeFriendRequestNotificationV2 then
		local v43

		v36, v43 = React.useState("")
		u37 = v43

		local v44

		v38, v44 = React.useState(false)
		u39 = v44

		local v45

		v40, v45 = React.useState(false)
		u41 = v45
		v42 = React.useCallback(function() -- line: 72
			-- upvalues: u41 (ref), u39 (ref)
			u41(false)
			u39(false)
		end, {})
	end

	local v46, v47 = React.useReducer(function(p3, p4) -- line: 78
		-- upvalues: IXPService (copy), getFStringProfileQRCodeFriendRequestAlertsLayer (copy), Cryo (copy)
		if p4.type == "addItemToQueue" then
			IXPService:LogUserLayerExposure(getFStringProfileQRCodeFriendRequestAlertsLayer())

			return Cryo.List.join(p3, { p4.newUserId })
		end

		if p4.type == "removeItemFromQueue" then
			return Cryo.List.removeIndex(p3, 1)
		end

		return p3
	end, {})
	local v48 = useLocalUserId()
	local v49 = useGetUsersInfoUrl()
	local v50 = useAcceptFriendUrl()
	local u51 = nil

	if FFlagQRCodeFriendRequestNotificationV2 then
		function u51(p5) -- line: 97
			-- upvalues: v48 (copy)
			local str = tostring(p5.UserId1)

			if str == v48 then
				str = tostring(p5.UserId2)
			end

			return str
		end
	end

	local function friendshipNotificationReceived(p6) -- line: 106
		-- upvalues: SignalREvents (copy), FriendsNetworking (copy), v48 (copy), v49 (copy), v47 (copy), FFlagQRCodeFriendRequestNotificationV2 (copy), u51 (ref), u37 (ref), u41 (ref), u39 (ref)
		if p6.Type == SignalREvents.FriendshipRequested and p6.EventArgs.SourceType == FriendsNetworking.Enums.FriendshipOriginSourceType.QrCode.rawValue() then
			local str = tostring(p6.EventArgs.UserId1)

			if str == v48 then
				str = tostring(p6.EventArgs.UserId2)
			end

			v49(str):andThen(function() -- line: 120
				-- upvalues: v47 (copy), str (ref)
				v47({
					type = "addItemToQueue",
					newUserId = str
				})
			end)

			return
		end

		if p6.Type == SignalREvents.FriendshipCreated and FFlagQRCodeFriendRequestNotificationV2 then
			local v61 = u51(p6.EventArgs)

			v49(v61):andThen(function() -- line: 126
				-- upvalues: u37 (ref), v61 (copy), u41 (ref), u39 (ref), p6 (copy)
				u37(v61)
				u41(true)
				u39(p6.EventArgs.IsTrustedFriend)
			end)
		end
	end

	React.useEffect(function() -- line: 134
		-- upvalues: robloxEventReceiver (copy), SignalREvents (copy), friendshipNotificationReceived (copy)
		robloxEventReceiver:observeEvent(SignalREvents.FriendshipNotifications, function(p7) -- line: 135
			-- upvalues: friendshipNotificationReceived (copy)
			friendshipNotificationReceived(p7)
		end)
	end, { robloxEventReceiver })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		ZIndex = 3,
		LayoutOrder = 1,
		Size = if not FFlagQRCodeFriendRequestNotificationV2 then UDim2.new(1, 0, 0, 56) else UDim2.new(1, 0, 1, 0)
	}, {
		TopBarWrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 3,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Layout = if FFlagQRCodeFriendRequestNotificationV2 then nil else React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			TopBar = React.createElement(ProfileQRCodeTopBar, {
				layoutOrder = 1,
				appStorageService = t1.appStorageService,
				onClose = t1.onClose,
				openQrCodeScanner = t1.openQrCodeScanner
			})
		}),
		FriendAcceptToastFrame = if not profileQRCodeFriendRequestAlertsEnabled or (not v34 or FFlagQRCodeFriendRequestNotificationV2) then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 100,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			FriendAcceptToast = React.createElement(Toast, {
				duration = 3,
				show = true,
				toastContent = {
					toastTitle = v30.friendAdded,
					iconImage = v28,
					onDismissed = function() -- line: 181
						-- upvalues: v35 (copy)
						v35(false)
					end
				}
			})
		}),
		FriendsInviteFrame = if not profileQRCodeFriendRequestAlertsEnabled or (not (#v46 > 0) or v34) then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 100,
			Position = UDim2.new(0, 0, 0, 24),
			Size = UDim2.new(1, 0, 1, 0)
		}, {
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
				notificationQueueSize = #v46,
				onAccept = function(p8) -- line: 212
					-- upvalues: v50 (copy), v48 (copy), v47 (copy), FFlagQRCodeFriendRequestNotificationV2 (copy), v35 (copy), v31 (copy), EventNames (copy), v46 (copy)
					v50(v48, p8):andThen(function() -- line: 213
						-- upvalues: v47 (copy), FFlagQRCodeFriendRequestNotificationV2 (copy), v35 (copy)
						v47({
							type = "removeItemFromQueue",
							newUserId = "0"
						})

						if not FFlagQRCodeFriendRequestNotificationV2 then
							v35(true)
						end
					end)
					v31.fireEvent(EventNames.QRPageFriendRequestBannerAccepted, {
						qrCodeBannerQueueSize = #v46
					})
				end,
				onClose = function() -- line: 223
					-- upvalues: v47 (copy), v31 (copy), EventNames (copy), v46 (copy)
					v47({
						type = "removeItemFromQueue",
						newUserId = "0"
					})
					v31.fireEvent(EventNames.QRPageFriendRequestBannerDismissed, {
						qrCodeBannerQueueSize = #v46
					})
				end,
				userId = tostring(v46[1])
			})
		}),
		FriendAcceptedSnackbar = if not v40 or not FFlagQRCodeFriendRequestNotificationV2 then nil else React.createElement(FriendAcceptedSnackbar, {
			acceptedFriendUserId = v36,
			newFriendIsTrusted = v38,
			onDismissed = v42
		})
	})
end))
