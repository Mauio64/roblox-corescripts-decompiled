local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/UIBlox")
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Common/TextKeys")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Localization").Hooks.useLocalization
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local useLocalUserInfo = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Utils/useLocalUserInfo")
local useAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/useAnalytics")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Analytics/EventNames")

local iconsmenuscanqr = images["icons/menu/scanqr"]
local iconsnavigationclose = images["icons/navigation/close"]

return function(props)
	local v5 = useLocalization({
		notificationRequest = TextKeys.NotificationRequestText,
		acceptFriend = TextKeys.AcceptFriend
	})

	local v6 = useStyle()
	local v7 = useLocalUserInfo(props.userId)
	local v8 = useAnalytics()

	local state, setState = React.useState(false)

	React.useEffect(function()
		v8.fireEvent(EventNames.QRPageFriendRequestBannerShown, {
			qrCodeBannerQueueSize = props.notificationQueueSize
		})
	end, { props.userId })

	return React.createElement("Frame", {
		ZIndex = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = v6.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = v6.Theme.BackgroundUIDefault.Transparency
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			PaddingTop = UDim.new(0, 12)
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		UIStroke = React.createElement("UIStroke", {
			Color = v6.Theme.Divider.Color,
			Transparency = v6.Theme.Divider.Transparency,
			Thickness = 1
		}),
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(640, 1e999)
		}),
		UpperFrame = React.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BorderSizePixel = 0
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 12)
			}),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			QRCodeImageFrame = React.createElement(
				"Frame",
				{
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 40, 0, 40),
					BorderSizePixel = 0
				},
				{
					QRImage = React.createElement(imageSetLabel, {
						Image = iconsmenuscanqr,
						BackgroundTransparency = 1,
						ImageTransparency = 0,
						ImageColor3 = v6.Theme.TextEmphasis.Color,
						Size = UDim2.new(0, 40, 0, 40)
					})
				}
			),
			TextFrame = React.createElement(
				"Frame",
				{
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -72, 0, 0),
					BorderSizePixel = 0
				},
				{
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 16),
						PaddingRight = UDim.new(0, 16)
					}),
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Username = React.createElement(styledTextLabel, {
						layoutOrder = 1,
						text = v7.displayName,
						fontStyle = v6.Font.Header2,
						colorStyle = v6.Theme.TextDefault,
						size = UDim2.new(1, 0, 0, 20),
						automaticSize = Enum.AutomaticSize.Y,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Center,
						textWrapped = true
					}),
					Spacer1 = React.createElement("Frame", {
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 5),
						LayoutOrder = 2
					}),
					Description = React.createElement(styledTextLabel, {
						layoutOrder = 3,
						text = v5.notificationRequest,
						fontStyle = v6.Font.Body,
						colorStyle = v6.Theme.TextDefault,
						size = UDim2.new(1, 0, 0, 28),
						automaticSize = Enum.AutomaticSize.Y,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Center,
						textWrapped = true,
						lineHeight = 1
					})
				}
			),
			CloseButtonFrame = React.createElement(
				"Frame",
				{
					LayoutOrder = 3,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 32, 0, 32),
					BorderSizePixel = 0
				},
				{
					CloseButton = React.createElement(iconButton, {
						icon = iconsnavigationclose,
						iconSize = iconSize.Medium,
						onActivated = props.onClose,
						anchorPoint = Vector2.new(0.13, 0.13)
					})
				}
			)
		}),
		AcceptButton = React.createElement(button, {
			buttonType = buttonType.PrimarySystem,
			layoutOrder = 2,
			standardSize = standardButtonSize.Small,
			text = v5.acceptFriend,
			fontStyle = v6.Font.CaptionBody,
			isDisabled = state,
			onActivated = function()
				setState(true)
				props.onAccept(props.userId)
			end
		})
	})
end
