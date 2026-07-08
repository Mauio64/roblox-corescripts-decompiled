local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local Constants = require(ProfilePlatform.Common.Constants)
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useStyleMetadata = UIBlox.Core.Style.useStyleMetadata
local LoadableImage = UIBlox.App.Loading.LoadableImage
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin

local function ContactProfileHeader(t1: {[any]: any}) -- line: 32
	-- upvalues: useLocalization (copy), TextKeys (copy), useStyle (copy), useStyleMetadata (copy), React (copy), ImageSetLabel (copy), Images (copy), LoadableImage (copy), Constants (copy), HorizontalPageMargin (copy), StyledTextLabel (copy)
	local v17 = useLocalization({
		contactsProfileBody = {
			TextKeys.ContactsProfileBody,
			contactName = t1.contactName
		},
		failedMessage = TextKeys.NoInternet,
		fromContacts = TextKeys.FromContacts
	})
	local v18 = useStyle()
	local v19 = useStyleMetadata()
	local Theme = v18.Theme
	local Font = v18.Font

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 400),
		LayoutOrder = t1.layoutOrder
	}, {
		Background = React.createElement(ImageSetLabel, {
			BorderSizePixel = 0,
			ZIndex = 1,
			Size = UDim2.fromScale(1, 1),
			Image = Images[v18.Theme.PlayerBackgroundDefault.Image],
			ImageColor3 = if not v19 or not v19.HasSurfaceOverrides then nil else v18.Theme.BackgroundUIDefault.Color:Lerp(v18.Theme.PlayerBackgroundDefault.Color, v18.Theme.Overlay.Transparency)
		}),
		AvatarThumbnail = React.createElement(LoadableImage, {
			BackgroundTransparency = 1,
			useShimmerAnimationWhileLoading = true,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, -48),
			Size = UDim2.new(1, -96, 1, -96),
			ScaleType = Enum.ScaleType.Fit,
			Image = t1.avatarThumbnailUrl
		}),
		TopGradient = React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 3,
			Size = UDim2.new(1, 0, 0, Constants.CONTACT_CARD_GRADIENT_HEIGHT),
			BackgroundColor3 = Theme.BackgroundDefault.Color
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		BottomGradient = React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 3,
			Size = UDim2.new(1, 0, 0, Constants.CONTACT_CARD_GRADIENT_HEIGHT),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = Theme.BackgroundDefault.Color
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
			})
		}),
		UserDetails = React.createElement(HorizontalPageMargin, {
			zIndex = 4,
			backgroundTransparency = 1,
			size = UDim2.new(1, 0, 0, 56),
			position = UDim2.fromScale(0, 0.9),
			anchorPoint = Vector2.new(0, 1)
		}, {
			UserDetailsLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Padding1 = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.fromOffset(0, 40)
			}),
			ContactName = React.createElement(StyledTextLabel, {
				layoutOrder = 2,
				text = t1.contactName,
				size = UDim2.new(1, 0, 0, 24),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				fontStyle = Font.Header1,
				colorStyle = Theme.TextEmphasis
			}),
			Padding2 = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.fromOffset(0, 15)
			}),
			FromContacts = React.createElement(StyledTextLabel, {
				layoutOrder = 4,
				size = UDim2.new(1, 0, 0, 16),
				text = v17.fromContacts,
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				fontStyle = Font.CaptionHeader,
				colorStyle = Theme.TextMuted
			})
		})
	})
end

return ContactProfileHeader
