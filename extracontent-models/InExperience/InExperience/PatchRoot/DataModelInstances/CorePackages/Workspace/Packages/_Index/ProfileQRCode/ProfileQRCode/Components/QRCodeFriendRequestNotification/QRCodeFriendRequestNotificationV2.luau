local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local UserTile = require(parent.UserTile)
local userTile = UserTile.UserTile
local UserTile2 = require(parent.UserTile)
local LayoutMode = UserTile2.LayoutMode

local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle

local Button = Foundation.Button
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local TextKeys = require(ProfileQRCode.Common.TextKeys)
local useLocalization = Localization.Hooks.useLocalization
local useLocalUserInfo = require(ProfileQRCode.Utils.useLocalUserInfo)
local useCombinedUserName = require(ProfileQRCode.Utils.useCombinedUserName)
local useAnalytics = require(ProfileQRCode.Analytics.useAnalytics)
local EventNames = require(ProfileQRCode.Analytics.EventNames)
local useTokens = Foundation.Hooks.useTokens

local FFlagProfileQrCodeDeprecateUserRedux = require(ProfileQRCode.Flags.FFlagProfileQrCodeDeprecateUserRedux)

return function(props)
	local v = useTokens()
	local v2 = useLocalization({
		notificationRequest = TextKeys.NotificationRequestText,
		accept = "CommonUI.Controls.Action.Accept",
		dismiss = "CommonUI.Messages.Action.Dismiss"
	})

	local v3 = useStyle()
	local v4 = useLocalUserInfo(props.userId)
	local v5 = useCombinedUserName(props.userId)
	local text

	if v5 == "" then
		text = v4 and (v4.displayName or v4.username or "") or ""
	else
		text = v5 .. " @" .. (v4.username or FFlagProfileQrCodeDeprecateUserRedux and "" or nil)
	end

	local v6 = useAnalytics()

	local state, setState = React.useState(false)

	React.useEffect(function()
		setState(false)
	end, { props.userId })

	React.useEffect(function()
		v6.fireEvent(EventNames.QRPageFriendRequestBannerShown, {
			qrCodeBannerQueueSize = props.notificationQueueSize
		})
	end, { props.userId, v6.fireEvent, props.notificationQueueSize })

	return React.createElement(View, {
		ZIndex = 2,
		tag = "col gap-medium size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium bg-surface-0",
		sizeConstraint = { MaxSize = Vector2.new(640, 1e999), MinSize = Vector2.new(0, 0) }
	}, {
		HeaderRow = React.createElement(
			View,
			{ tag = "row align-y-top gap-medium size-full-0 auto-y", LayoutOrder = 1 },
			{
				AvatarSlot = React.createElement(View, { tag = "no-flex auto-xy", LayoutOrder = 1 }, {
					UserTile = React.createElement(userTile, {
						userId = props.userId,
						layoutMode = LayoutMode.compact,
						userPresenceType = Foundation.Enums.UserPresence.None,
						avatarSize = UDim2.new(0, v.Size.Size_1000, 0, v.Size.Size_1000)
					})
				}),
				ContentColumn = React.createElement(View, {
					tag = "col fill gap-xsmall auto-y",
					LayoutOrder = 2
				}, {
					Username = React.createElement(StyledTextLabel, {
						layoutOrder = 1,
						text = text,
						fontStyle = v3.Font.Header2,
						colorStyle = v3.Theme.TextDefault,
						size = UDim2.new(1, 0, 0, v.Size.Size_500),
						automaticSize = Enum.AutomaticSize.Y,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Center,
						textWrapped = true
					}),
					Description = React.createElement(StyledTextLabel, {
						layoutOrder = 2,
						text = v2.notificationRequest,
						fontStyle = v3.Font.Body,
						colorStyle = v3.Theme.TextDefault,
						size = UDim2.new(1, 0, 0, v.Size.Size_700),
						automaticSize = Enum.AutomaticSize.Y,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Center,
						textWrapped = true,
						lineHeight = 1
					}),
					ButtonRow = React.createElement(
						View,
						{
							tag = "row gap-small size-full-0 auto-y padding-top-large",
							LayoutOrder = 3
						},
						{
							AcceptSlot = React.createElement(View, {
								tag = "fill auto-xy",
								LayoutOrder = 1
							}, {
								AcceptButton = React.createElement(Button, {
									text = v2.accept,
									variant = ButtonVariant.Emphasis,
									size = InputSize.Small,
									fillBehavior = FillBehavior.Fill,
									isDisabled = state,
									onActivated = function()
										setState(true)
										props.onAccept(props.userId)
									end
								})
							}),
							DismissSlot = React.createElement(View, {
								tag = "fill auto-xy",
								LayoutOrder = 2
							}, {
								DismissButton = React.createElement(Button, {
									text = v2.dismiss,
									variant = ButtonVariant.Standard,
									size = InputSize.Small,
									fillBehavior = FillBehavior.Fill,
									onActivated = props.onClose
								})
							})
						}
					)
				})
			}
		)
	})
end
