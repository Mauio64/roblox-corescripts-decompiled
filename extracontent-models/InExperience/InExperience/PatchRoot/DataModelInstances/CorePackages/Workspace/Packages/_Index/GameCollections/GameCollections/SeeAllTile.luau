local parent = script:FindFirstAncestor("GameCollections").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local Images = UIBlox.App.ImageSet.Images
local useCursor = UIBlox.App.SelectionCursor.useCursor
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local useTokens = Foundation.Hooks.useTokens
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiComponentsUseFoundationTokens = SharedFlags.FFlagSduiComponentsUseFoundationTokens

local iconsnavigationpushRight = Images["icons/navigation/pushRight"]

function SeeAllTile(props)
	local size = props.size
	local layoutOrder = props.layoutOrder
	local v

	if FFlagSduiComponentsUseFoundationTokens then
		v = useTokens()
	else
		v = useDesignTokens()
	end

	local v2 = useLocalization({ seeAll = "Feature.Home.ActionSeeAll" })

	local udim = UDim.new(0, v.Size.Size_200)

	local selectionImageObject = useCursor(udim)

	local titleLarge = v.Typography.TitleLarge
	local color3 = v.Color.Content.Emphasis.Color3
	local color3_2 = v.Color.Content.Emphasis.Color3
	local transparency = v.Color.Content.Emphasis.Transparency

	local title = props.title or v2.seeAll
	local icon = props.icon or iconsnavigationpushRight
	local size_900 = v.Size.Size_900

	return React.createElement("TextButton", {
		AutoButtonColor = false,
		Text = "",
		Size = size,
		LayoutOrder = layoutOrder,
		BackgroundTransparency = v.Color.Surface.Surface_300.Transparency,
		BackgroundColor3 = v.Color.Surface.Surface_300.Color3,
		[React.Event.Activated] = props.onActivated,
		SelectionImageObject = selectionImageObject
	}, {
		UICorner = React.createElement("UICorner", { CornerRadius = udim }),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v.Size.Size_100)
		}),
		Icon = React.createElement(ImageSetLabel, {
			Size = UDim2.fromOffset(size_900, size_900),
			BackgroundTransparency = 1,
			Image = icon,
			ImageColor3 = color3_2,
			ImageTransparency = transparency,
			LayoutOrder = 1
		}),
		Title = React.createElement("TextLabel", {
			Text = title,
			Size = UDim2.new(1, 0, 0, titleLarge.FontSize),
			TextXAlignment = Enum.TextXAlignment.Center,
			LayoutOrder = 2,
			FontFace = normalizeFontFace(titleLarge.Font),
			TextSize = titleLarge.FontSize,
			TextColor3 = color3,
			TextTruncate = Enum.TextTruncate.AtEnd,
			BackgroundTransparency = 1
		})
	})
end

return SeeAllTile
