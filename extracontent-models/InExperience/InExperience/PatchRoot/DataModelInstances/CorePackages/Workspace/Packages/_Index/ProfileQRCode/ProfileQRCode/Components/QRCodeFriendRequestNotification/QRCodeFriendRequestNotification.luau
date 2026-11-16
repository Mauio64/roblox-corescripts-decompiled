local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local TextKeys = require(ProfileQRCode.Common.TextKeys)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local useLocalUserInfo = require(ProfileQRCode.Utils.useLocalUserInfo)
local useAnalytics = require(ProfileQRCode.Analytics.useAnalytics)
local EventNames = require(ProfileQRCode.Analytics.EventNames)

local iconsmenuscanqr = Images["icons/menu/scanqr"]
local iconsnavigationclose = Images["icons/navigation/close"]

return function(props)
	local v = useLocalization({
		notificationRequest = TextKeys.NotificationRequestText,
		acceptFriend = TextKeys.AcceptFriend
	})

	local v2 = useStyle()
	local v3 = useLocalUserInfo(props.userId)
	local v4 = useAnalytics()

	local state, setState = React.useState(false)

	React.useEffect(function()
		v4.fireEvent(EventNames.QRPageFriendRequestBannerShown, {
			qrCodeBannerQueueSize = props.notificationQueueSize
		})
	end, { props.userId })

	return React.createElement("Frame", {
		ZIndex = 2,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = v2.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = v2.Theme.BackgroundUIDefault.Transparency
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			PaddingTop = UDim.new(0, 12)
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		UIStroke = React.createElement("UIStroke", {
			Color = v2.Theme.Divider.Color,
			Transparency = v2.Theme.Divider.Transparency,
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
			UIPadding = React.createElement("UIPadding", { PaddingBottom = UDim.new(0, 12) }),
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
					QRImage = React.createElement(ImageSetLabel, {
						Image = iconsmenuscanqr,
						BackgroundTransparency = 1,
						ImageTransparency = 0,
						ImageColor3 = v2.Theme.TextEmphasis.Color,
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
					Username = React.createElement(StyledTextLabel, {
						layoutOrder = 1,
						text = v3.displayName,
						fontStyle = v2.Font.Header2,
						colorStyle = v2.Theme.TextDefault,
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
					Description = React.createElement(StyledTextLabel, {
						layoutOrder = 3,
						text = v.notificationRequest,
						fontStyle = v2.Font.Body,
						colorStyle = v2.Theme.TextDefault,
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
					CloseButton = React.createElement(IconButton, {
						icon = iconsnavigationclose,
						iconSize = IconSize.Medium,
						onActivated = props.onClose,
						anchorPoint = Vector2.new(0.13, 0.13)
					})
				}
			)
		}),
		AcceptButton = React.createElement(Button, {
			buttonType = ButtonType.PrimarySystem,
			layoutOrder = 2,
			standardSize = StandardButtonSize.Small,
			text = v.acceptFriend,
			fontStyle = v2.Font.CaptionBody,
			isDisabled = state,
			onActivated = function()
				setState(true)
				props.onAccept(props.userId)
			end
		})
	})
end
