local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Constants = require(ProfilePlatform.Common.Constants)
local TextKeys = require(ProfilePlatform.Common.TextKeys)

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata

local LoadableImage = UIBlox.App.Loading.LoadableImage
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin

local function ContactProfileHeader(props)
	local v = useLocalization({
		contactsProfileBody = {
			TextKeys.ContactsProfileBody,
			contactName = props.contactName
		},
		failedMessage = TextKeys.NoInternet,
		fromContacts = TextKeys.FromContacts
	})

	local v2 = useStyle()
	local v3 = useStyleMetadata()
	local theme = v2.Theme
	local font = v2.Font

	local createElement = React.createElement
	local v4 = {
		Size = UDim2.new(1, 0, 0, 400),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement
	local v5 = {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		Image = Images[v2.Theme.PlayerBackgroundDefault.Image],
		ImageColor3 = 0,
		ZIndex = 1
	}
	local imageColor

	if v3 and v3.HasSurfaceOverrides then
		imageColor = v2.Theme.BackgroundUIDefault.Color:Lerp(
			v2.Theme.PlayerBackgroundDefault.Color,
			v2.Theme.Overlay.Transparency
		)
	end

	v5.ImageColor3 = imageColor
	return createElement("Frame", v4, {
		Background = createElement2(ImageSetLabel, v5),
		AvatarThumbnail = React.createElement(LoadableImage, {
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
				Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })
			})
		}),
		UserDetails = React.createElement(HorizontalPageMargin, {
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
			ContactName = React.createElement(StyledTextLabel, {
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
			FromContacts = React.createElement(StyledTextLabel, {
				size = UDim2.new(1, 0, 0, 16),
				text = v.fromContacts,
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
