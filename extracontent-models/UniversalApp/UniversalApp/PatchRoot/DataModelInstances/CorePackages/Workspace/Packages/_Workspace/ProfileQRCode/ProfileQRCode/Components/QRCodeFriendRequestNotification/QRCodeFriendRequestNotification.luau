local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local React = require(ProfileQRCodeParent.React)
local UIBlox = require(ProfileQRCodeParent.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local TextKeys = require(ProfileQRCode.Common.TextKeys)
local useLocalization = require(ProfileQRCodeParent.Localization).Hooks.useLocalization
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
local FFlagConnectionsToFriendsRename = require(ProfileQRCodeParent.SharedFlags).FFlagConnectionsToFriendsRename
local v20 = Images["icons/menu/scanqr"]
local v21 = Images["icons/navigation/close"]

return function(t1: {[any]: any}) -- line: 46
	-- upvalues: useLocalization (copy), TextKeys (copy), FFlagConnectionsToFriendsRename (copy), useStyle (copy), useLocalUserInfo (copy), useAnalytics (copy), React (copy), EventNames (copy), ImageSetLabel (copy), v20 (copy), StyledTextLabel (copy), IconButton (copy), v21 (copy), IconSize (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy)
	local v23 = useLocalization({
		notificationRequest = TextKeys.NotificationRequestText,
		acceptFriend = if not FFlagConnectionsToFriendsRename then TextKeys.AcceptConnection else TextKeys.AcceptFriend
	})
	local v24 = useStyle()
	local v25 = useLocalUserInfo(t1.userId)
	local v26 = useAnalytics()
	local v27, v28 = React.useState(false)

	React.useEffect(function() -- line: 57
		-- upvalues: v26 (copy), EventNames (copy), t1 (copy)
		v26.fireEvent(EventNames.QRPageFriendRequestBannerShown, {
			qrCodeBannerQueueSize = t1.notificationQueueSize
		})
	end, { t1.userId })

	return React.createElement("Frame", {
		ZIndex = 2,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundColor3 = v24.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = v24.Theme.BackgroundUIDefault.Transparency
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			PaddingTop = UDim.new(0, 12)
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		UIStroke = React.createElement("UIStroke", {
			Thickness = 1,
			Color = v24.Theme.Divider.Color,
			Transparency = v24.Theme.Divider.Transparency
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
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 12)
			}),
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			QRCodeImageFrame = React.createElement("Frame", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0, 40, 0, 40)
			}, {
				QRImage = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					ImageTransparency = 0,
					Image = v20,
					ImageColor3 = v24.Theme.TextEmphasis.Color,
					Size = UDim2.new(0, 40, 0, 40)
				})
			}),
			TextFrame = React.createElement("Frame", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -72, 0, 0)
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 16),
					PaddingRight = UDim.new(0, 16)
				}),
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Username = React.createElement(StyledTextLabel, {
					layoutOrder = 1,
					textWrapped = true,
					text = v25.displayName,
					fontStyle = v24.Font.Header2,
					colorStyle = v24.Theme.TextDefault,
					size = UDim2.new(1, 0, 0, 20),
					automaticSize = Enum.AutomaticSize.Y,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center
				}),
				Spacer1 = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 5)
				}),
				Description = React.createElement(StyledTextLabel, {
					layoutOrder = 3,
					textWrapped = true,
					lineHeight = 1,
					text = v23.notificationRequest,
					fontStyle = v24.Font.Body,
					colorStyle = v24.Theme.TextDefault,
					size = UDim2.new(1, 0, 0, 28),
					automaticSize = Enum.AutomaticSize.Y,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center
				})
			}),
			CloseButtonFrame = React.createElement("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0, 32, 0, 32)
			}, {
				CloseButton = React.createElement(IconButton, {
					icon = v21,
					iconSize = IconSize.Medium,
					onActivated = t1.onClose,
					anchorPoint = Vector2.new(0.13, 0.13)
				})
			})
		}),
		AcceptButton = React.createElement(Button, {
			layoutOrder = 2,
			buttonType = ButtonType.PrimarySystem,
			standardSize = StandardButtonSize.Small,
			text = v23.acceptFriend,
			fontStyle = v24.Font.CaptionBody,
			isDisabled = v27,
			onActivated = function() -- line: 184
				-- upvalues: v28 (copy), t1 (copy)
				v28(true)
				t1.onAccept(t1.userId)
			end
		})
	})
end
