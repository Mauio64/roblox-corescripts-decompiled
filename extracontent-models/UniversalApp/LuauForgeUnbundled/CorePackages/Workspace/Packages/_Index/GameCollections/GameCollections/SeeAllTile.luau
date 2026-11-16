local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local images = UIBlox.App.ImageSet.Images
local useCursor = UIBlox.App.SelectionCursor.useCursor
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Localization").Hooks.useLocalization
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Style").useDesignTokens
local useTokens = Foundation.Hooks.useTokens
local fFlagSduiComponentsUseFoundationTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagSduiComponentsUseFoundationTokens

local iconsnavigationpushRight = images["icons/navigation/pushRight"]

function LUAUFORGE_MODULE_GLOBALS_bPP_SeeAllTile(props)
	local size = props.size
	local layoutOrder = props.layoutOrder

	local v5 = if fFlagSduiComponentsUseFoundationTokens then useTokens() else useDesignTokens()
	local v6 = useLocalization({ seeAll = "Feature.Home.ActionSeeAll" })

	local udim = UDim.new(0, v5.Size.Size_200)

	local v7 = useCursor(udim)

	local titleLarge = v5.Typography.TitleLarge
	local color3 = v5.Color.Content.Emphasis.Color3
	local color3_2 = v5.Color.Content.Emphasis.Color3
	local transparency = v5.Color.Content.Emphasis.Transparency

	local title = props.title or v6.seeAll
	local icon = props.icon or iconsnavigationpushRight
	local size_900 = v5.Size.Size_900

	local createElement = React.createElement
	local onActivatedsByActivated = {
		AutoButtonColor = false,
		Text = "",
		Size = size,
		LayoutOrder = layoutOrder,
		BackgroundTransparency = v5.Color.Surface.Surface_300.Transparency,
		BackgroundColor3 = v5.Color.Surface.Surface_300.Color3,
		[React.Event.Activated] = props.onActivated,
		SelectionImageObject = v7
	}

	local v9 = {
		UICorner = React.createElement("UICorner", { CornerRadius = udim }),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v5.Size.Size_100)
		}),
		Icon = React.createElement(imageSetLabel, {
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
	local v11 = {
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

	local v12 = if not foundationFontFaceMigration then titleLarge.Font else nil
	v11.Font = v12
	local v13 = if foundationFontFaceMigration then normalizeFontFace(titleLarge.Font) else nil
	v11.FontFace = v13
	v11.TextSize = titleLarge.FontSize
	v11.TextColor3 = color3
	v11.TextTruncate = Enum.TextTruncate.AtEnd
	v9.Title = createElement2("TextLabel", v11)
	return createElement("TextButton", onActivatedsByActivated, v9)
end

return LUAUFORGE_MODULE_GLOBALS_bPP_SeeAllTile
