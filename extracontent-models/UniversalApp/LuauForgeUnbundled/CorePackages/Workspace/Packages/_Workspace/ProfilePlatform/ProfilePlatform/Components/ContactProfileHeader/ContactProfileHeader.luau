local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata

local loadableImage = UIBlox.App.Loading.LoadableImage
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local images = UIBlox.App.ImageSet.Images
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local horizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin

local function ContactProfileHeader(props)
	local v5 = useLocalization({
		contactsProfileBody = {
			TextKeys.ContactsProfileBody,
			contactName = props.contactName
		},
		failedMessage = TextKeys.NoInternet,
		fromContacts = TextKeys.FromContacts
	})

	local v6 = useStyle()
	local v7 = useStyleMetadata()
	local theme = v6.Theme
	local font = v6.Font

	local createElement = React.createElement
	local v9 = {
		Size = UDim2.new(1, 0, 0, 400),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement
	local v11 = {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		Image = images[v6.Theme.PlayerBackgroundDefault.Image],
		ImageColor3 = 0,
		ZIndex = 1
	}
	local v12 = if v7 and v7.HasSurfaceOverrides then v6.Theme.BackgroundUIDefault.Color:Lerp(
		v6.Theme.PlayerBackgroundDefault.Color,
		v6.Theme.Overlay.Transparency
	) else nil
	v11.ImageColor3 = v12
	return createElement("Frame", v9, {
		Background = createElement2(imageSetLabel, v11),
		AvatarThumbnail = React.createElement(loadableImage, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, -48),
			Size = UDim2.new(1, -96, 1, -96),
			ScaleType = Enum.ScaleType.Fit,
			BackgroundTransparency = 1,
			Image = props.avatarThumbnailUrl,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 2
		}),
		TopGradient = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, Constants.CONTACT_CARD_GRADIENT_HEIGHT),
				BackgroundColor3 = theme.BackgroundDefault.Color,
				BorderSizePixel = 0,
				ZIndex = 3
			},
			{
				UIGradient = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			}
		),
		BottomGradient = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, Constants.CONTACT_CARD_GRADIENT_HEIGHT),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = theme.BackgroundDefault.Color,
			BorderSizePixel = 0,
			ZIndex = 3
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
			})
		}),
		UserDetails = React.createElement(horizontalPageMargin, {
			size = UDim2.new(1, 0, 0, 56),
			position = UDim2.fromScale(0, 0.9),
			anchorPoint = Vector2.new(0, 1),
			zIndex = 4,
			backgroundTransparency = 1
		}, {
			UserDetailsLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding1 = React.createElement("Frame", {
				Size = UDim2.fromOffset(0, 40),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			}),
			ContactName = React.createElement(styledTextLabel, {
				text = props.contactName,
				size = UDim2.new(1, 0, 0, 24),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				fontStyle = font.Header1,
				colorStyle = theme.TextEmphasis,
				layoutOrder = 2
			}),
			Padding2 = React.createElement("Frame", {
				Size = UDim2.fromOffset(0, 15),
				BackgroundTransparency = 1,
				LayoutOrder = 3
			}),
			FromContacts = React.createElement(styledTextLabel, {
				size = UDim2.new(1, 0, 0, 16),
				text = v5.fromContacts,
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				fontStyle = font.CaptionHeader,
				colorStyle = theme.TextMuted,
				layoutOrder = 4
			})
		})
	})
end

return ContactProfileHeader
