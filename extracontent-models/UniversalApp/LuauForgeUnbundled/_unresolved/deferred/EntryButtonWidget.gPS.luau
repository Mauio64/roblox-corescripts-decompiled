local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useStyle = UIBlox.Core.Style.useStyle
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module = require("@luauforge/bundled/eeH")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useSelectedTheme = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useSelectedTheme
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local module2 = require("@luauforge/bundled/fvF")
local module3 = require("@luauforge/deferred/gPT")
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local widgetConstants = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").WidgetConstants
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore

if fFlagSignalsNavP3gAvatarExperience then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local function EntryButtonWidget(props)
	local v5 = useNavigation()
	local v6 = module(module2)
	local v7 = useSelector(function(p2)
		return p2.AvatarExperience.Common.Widgets.WidgetInfo.RequestId
	end, getUseSelectorDeepEquals())
	local v8

	if fFlagSignalsNavP3gAvatarExperience then
		v8 = nil
	else
		v8 = useSelector(function(p2)
			if fFlagUseNavigationSelectors then
				return (selectors.selectLegacyHistory(p2))
			end

			return p2.Navigation.history
		end, getUseSelectorDeepEquals())
	end

	local v9 = useSelectedTheme() == "dark"
	local v10 = useStyle()
	local theme = v10.Theme
	local font = v10.Font

	local widgetInfo = props.widgetInfo
	local kind = widgetInfo.type
	local v11 = if kind then widgetConstants.TypeToImageInfo[kind] else nil
	local function fn()
		v6.widgetInteraction(
			v7,
			widgetConstants.ActionType.WIDGET_CLICK,
			nil,
			props.widgetRow,
			nil,
			nil,
			widgetInfo.id
		)
		local v12

		if fFlagSignalsNavP3gAvatarExperience then
			v12 = getLegacyNavigationStore(false).getHistory(false)
		else
			v12 = v8
		end

		module3.getEntryButtonWidgetActivationFunc(kind, v5, v12)()
	end

	local rowHeight = props.rowHeight
	local v12, v13

	if v11 then
		rowHeight *= v11.rowScale
		v12 = if v9 then v11.backgroundImageDark else v11.backgroundImageLight
		v13 = if v9 then v11.contentImageDark else v11.contentImageLight
	end

	local v14 = not v11 and 1.5 or v11.widthHeightRatio

	local v17 = if widgetInfo and widgetInfo.template then widgetInfo.template.title else nil
	local v18 = if widgetInfo and widgetInfo.template then widgetInfo.template.description else nil
	local v19 = useLocalization({ titleText = v17, descText = v18 })

	local v20 = useSelectionCursor(cursorKind.RoundedRect)

	local createElement = React.createElement
	local v22 = {
		Size = UDim2.new(1, 0, 0, rowHeight),
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local imageButton = focusable.ImageButton
	local v24 = {
		Size = UDim2.new(1, -3, 1, 0),
		Position = UDim2.fromOffset(1, 0),
		BackgroundTransparency = 1,
		Image = v12,
		ScaleType = Enum.ScaleType.Crop,
		[React.Event.Activated] = fn,
		ClipsDescendants = true,
		SelectionImageObject = v20
	}

	local children = {
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		UIStroke = React.createElement("UIStroke", {
			Color = theme.Divider.Color,
			Transparency = theme.Divider.Transparency,
			Thickness = 1
		}),
		TextFrame = 0,
		ContentImageLabel = 0
	}

	local createElement3 = React.createElement
	local v26 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }
	local v27 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 8)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 24),
			PaddingRight = UDim.new(0, 24)
		}),
		Title = 0,
		Description = 0
	}
	local v28

	if v19.titleText then
		local createElement4 = React.createElement
		local v30 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextWrapped = false,
			TextXAlignment = 0,
			LayoutOrder = 1
		}

		local v31 = if not foundationFontFaceMigration then font.Header1.Font else nil
		v30.Font = v31

		local v32 = if foundationFontFaceMigration then normalizeFontFace(v10.Tokens.Typography.HeadingSmall.Font) else nil
		v30.FontFace = v32

		v30.Text = v19.titleText
		v30.TextColor3 = Color3.fromRGB(255, 255, 255)
		v30.TextSize = font.BaseSize * font.Header1.RelativeSize

		v30.TextXAlignment = Enum.TextXAlignment.Left
		v28 = createElement4("TextLabel", v30)
	end

	v27.Title = v28
	local v29

	if v19.descText then
		local createElement4 = React.createElement
		local v31 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextWrapped = false,
			TextXAlignment = 0,
			LayoutOrder = 2
		}

		local v32 = if not foundationFontFaceMigration then font.SubHeader1.Font else nil
		v31.Font = v32

		local v33 = if foundationFontFaceMigration then normalizeFontFace(v10.Tokens.Typography.TitleLarge.Font) else nil
		v31.FontFace = v33

		v31.Text = v19.descText
		v31.TextColor3 = Color3.fromRGB(255, 255, 255)
		v31.TextSize = font.BaseSize * font.SubHeader1.RelativeSize

		v31.TextXAlignment = Enum.TextXAlignment.Left
		v29 = createElement4("TextLabel", v31)
	end

	v27.Description = v29
	children.TextFrame = createElement3("Frame", v26, v27)

	children.ContentImageLabel = React.createElement("ImageLabel", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.fromScale(1, 0.5),
		BackgroundTransparency = 1,
		Image = v13,
		Size = UDim2.fromOffset(rowHeight * v14, rowHeight)
	})
	return createElement("Frame", v22, {
		EntryButton = createElement2(imageButton, v24, children)
	})
end

return EntryButtonWidget
