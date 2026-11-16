local parent = script:FindFirstAncestor("GameCollections").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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

	local createElement = React.createElement
	local onActivatedsByActivated = {
		AutoButtonColor = false,
		Text = "",
		Size = size,
		LayoutOrder = layoutOrder,
		BackgroundTransparency = v.Color.Surface.Surface_300.Transparency,
		BackgroundColor3 = v.Color.Surface.Surface_300.Color3,
		[React.Event.Activated] = props.onActivated,
		SelectionImageObject = selectionImageObject
	}

	local v3 = {
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
		Title = 0
	}

	local createElement2 = React.createElement
	local v4 = {
		Text = title,
		Size = UDim2.new(1, 0, 0, titleLarge.FontSize),
		TextXAlignment = Enum.TextXAlignment.Center,
		LayoutOrder = 2,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTruncate = 0,
		BackgroundTransparency = 1
	}
	local font

	if not FoundationFontFaceMigration then
		font = titleLarge.Font
	end

	v4.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(titleLarge.Font)
	end

	v4.FontFace = fontFace
	v4.TextSize = titleLarge.FontSize
	v4.TextColor3 = color3
	v4.TextTruncate = Enum.TextTruncate.AtEnd
	v3.Title = createElement2("TextLabel", v4)
	return createElement("TextButton", onActivatedsByActivated, v3)
end

return SeeAllTile
