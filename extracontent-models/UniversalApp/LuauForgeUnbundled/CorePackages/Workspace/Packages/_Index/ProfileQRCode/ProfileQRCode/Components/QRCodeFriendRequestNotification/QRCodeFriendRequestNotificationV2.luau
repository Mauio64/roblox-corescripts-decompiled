local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Localization")
local userTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/UserTile").UserTile
local layoutMode = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/UserTile").LayoutMode

local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle

local button = Foundation.Button
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Common/TextKeys")
local useLocalization = Localization.Hooks.useLocalization
local useLocalUserInfo = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Utils/useLocalUserInfo")
local useCombinedUserName = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Utils/useCombinedUserName")
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/useAnalytics")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/EventNames")
local useTokens = Foundation.Hooks.useTokens

local FFlagProfileQrCodeDeprecateUserRedux = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Flags/FFlagProfileQrCodeDeprecateUserRedux")

return function(props)
	local v5 = useTokens()
	local v6 = useLocalization({
		notificationRequest = TextKeys.NotificationRequestText,
		accept = "CommonUI.Controls.Action.Accept",
		dismiss = "CommonUI.Messages.Action.Dismiss"
	})

	local v7 = useStyle()
	local v8 = useLocalUserInfo(props.userId)
	local v9 = useCombinedUserName(props.userId)
	local v10

	if v9 == "" then
		v10 = v8 and (v8.displayName or v8.username or "") or ""
	else
		v10 = v9 .. " @" .. (v8.username or FFlagProfileQrCodeDeprecateUserRedux and "" or nil)
	end

	local v11 = useAnalytics()

	local state, setState = React.useState(false)

	React.useEffect(function()
		setState(false)
	end, { props.userId })

	React.useEffect(function()
		v11.fireEvent(EventNames.QRPageFriendRequestBannerShown, {
			qrCodeBannerQueueSize = props.notificationQueueSize
		})
	end, { props.userId, v11.fireEvent, props.notificationQueueSize })

	return React.createElement(view, {
		ZIndex = 2,
		tag = "col gap-medium size-full-0 auto-y padding-medium stroke-standard stroke-default radius-medium bg-surface-0",
		sizeConstraint = {
			MaxSize = Vector2.new(640, 1e999),
			MinSize = Vector2.new(0, 0)
		}
	}, {
		HeaderRow = React.createElement(
			view,
			{ tag = "row align-y-top gap-medium size-full-0 auto-y", LayoutOrder = 1 },
			{
				AvatarSlot = React.createElement(view, {
					tag = "no-flex auto-xy",
					LayoutOrder = 1
				}, {
					UserTile = React.createElement(userTile, {
						userId = props.userId,
						layoutMode = layoutMode.compact,
						userPresenceType = Foundation.Enums.UserPresence.None,
						avatarSize = UDim2.new(0, v5.Size.Size_1000, 0, v5.Size.Size_1000)
					})
				}),
				ContentColumn = React.createElement(
					view,
					{ tag = "col fill gap-xsmall auto-y", LayoutOrder = 2 },
					{
						Username = React.createElement(styledTextLabel, {
							layoutOrder = 1,
							text = v10,
							fontStyle = v7.Font.Header2,
							colorStyle = v7.Theme.TextDefault,
							size = UDim2.new(1, 0, 0, v5.Size.Size_500),
							automaticSize = Enum.AutomaticSize.Y,
							textXAlignment = Enum.TextXAlignment.Left,
							textYAlignment = Enum.TextYAlignment.Center,
							textWrapped = true
						}),
						Description = React.createElement(styledTextLabel, {
							layoutOrder = 2,
							text = v6.notificationRequest,
							fontStyle = v7.Font.Body,
							colorStyle = v7.Theme.TextDefault,
							size = UDim2.new(1, 0, 0, v5.Size.Size_700),
							automaticSize = Enum.AutomaticSize.Y,
							textXAlignment = Enum.TextXAlignment.Left,
							textYAlignment = Enum.TextYAlignment.Center,
							textWrapped = true,
							lineHeight = 1
						}),
						ButtonRow = React.createElement(
							view,
							{
								tag = "row gap-small size-full-0 auto-y padding-top-large",
								LayoutOrder = 3
							},
							{
								AcceptSlot = React.createElement(
									view,
									{ tag = "fill auto-xy", LayoutOrder = 1 },
									{
										AcceptButton = React.createElement(button, {
											text = v6.accept,
											variant = buttonVariant.Emphasis,
											size = inputSize.Small,
											fillBehavior = fillBehavior.Fill,
											isDisabled = state,
											onActivated = function()
												setState(true)
												props.onAccept(props.userId)
											end
										})
									}
								),
								DismissSlot = React.createElement(
									view,
									{ tag = "fill auto-xy", LayoutOrder = 2 },
									{
										DismissButton = React.createElement(button, {
											text = v6.dismiss,
											variant = buttonVariant.Standard,
											size = inputSize.Small,
											fillBehavior = fillBehavior.Fill,
											onActivated = props.onClose
										})
									}
								)
							}
						)
					}
				)
			}
		)
	})
end
