local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useSelectedTheme = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useSelectedTheme
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module = require("@luauforge/bundled/fTi")
local iconWithTooltip = require("@game/CorePackages/Workspace/Packages/AppBlox").IconWithTooltip
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local Foundation = require(CorePackages.Packages.Foundation)

local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local grid = require("@luauforge/deferred/gkN").GridComponents.Grid
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local module2 = require("@luauforge/bundled/dMx")

local module3 = require("@luauforge/deferred/gTQ")
local module4 = require("@luauforge/deferred/gTR")

local widgetListHorizontalMargin = module2.WidgetListHorizontalMargin

local function SponsoredItems(props)
	local layoutOrder = props.LayoutOrder
	local numItemsPerRow = props.numItemsPerRow

	local v5 = useStyle()
	local v6 = useSelectedTheme() == "dark"

	local v7 = module({
		sponsored = "Feature.GamePage.Label.Sponsored",
		sponsoredDisclosure = "Feature.GamePage.Label.SponsoredDisclosure"
	})

	local v8 = useTokens()

	local v9 = useSelector(module4, getUseSelectorDeepEquals())

	local v10 = numItemsPerRow * (module2.SponsoredItemsRow - 1)

	local v11 = React.useMemo(function()
		if v9 and numItemsPerRow > 0 then
			return Cryo.List.getRange(v9, 1, numItemsPerRow)
		end

		return nil
	end, { v9, numItemsPerRow })

	local font = v5.Font
	local font2 = font.Body.Font
	local v12 = font.BaseSize * font.Header2.RelativeSize

	local theme = v5.Theme
	local v13 = if v6 then theme.BackgroundMuted else theme.BackgroundContrast

	local createElement = React.createElement
	local frame = RoactGamepad.Focusable.Frame
	local v14 = {
		Size = UDim2.new(1, widgetListHorizontalMargin * 2, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = v13.Transparency,
		BackgroundColor3 = v13.Color,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		onFocusGained = props.moveFocusToColumn
	}
	local children = {
		ImpressionsTracker = React.createElement(module3, {
			visibleItems = v11 or {},
			scrollingFrameRef = props.scrollingFrameRef,
			sponsoredGridRef = props.sponsoredGridRef,
			requestImpressionsSignal = props.requestImpressionsSignal,
			indexOffset = v10
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, widgetListHorizontalMargin),
			PaddingRight = UDim.new(0, widgetListHorizontalMargin),
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		SponsoredLabel = 0,
		GridView = 0
	}

	local createElement2 = React.createElement
	local v16 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1
	}

	local children2 = {
		SponsoredUIListLayout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, v5.Tokens.Size.Size_100),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		SponsoredTitle = 0,
		SponsoredTooltip = 0
	}

	local createElement3 = React.createElement

	if foundationFontFaceMigration then
		font2 = nil
	end

	local v19 = if foundationFontFaceMigration then normalizeFontFace(v8.Typography.BodyLarge.Font) else nil
	children2.SponsoredTitle = createElement3("TextLabel", {
		BackgroundTransparency = 1,
		Font = font2,
		FontFace = v19,
		Text = v7.sponsored,
		AutomaticSize = Enum.AutomaticSize.XY,
		TextWrapped = true,
		TextSize = v12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextColor3 = theme.TextMuted.Color,
		LayoutOrder = 1
	})

	children2.SponsoredTooltip = React.createElement(iconWithTooltip, {
		tooltipOrientation = tooltipOrientation.Right,
		onActivateTooltip = props.onActivateTooltipCallback,
		anchorPoint = Vector2.new(1, 0),
		layoutOrder = 2,
		hoverText = v7.sponsoredDisclosure,
		triggerPointName = "SponsoredTooltip",
		supportTenFootUi = true,
		supportVR = true
	})
	children.SponsoredLabel = createElement2("Frame", v16, children2)

	children.GridView = React.createElement(RoactGamepad.Focusable.Frame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		ref = props.sponsoredGridRef,
		restorePreviousChildFocus = true,
		onFocusGained = props.onFocusGained,
		LayoutOrder = 2
	}, React.createElement(grid, {
		itemsPerRow = numItemsPerRow,
		getItemId = function(p2)
			return p2.id
		end,
		gapHorizontal = v8.Gap.Small,
		gapVertical = v8.Gap.Large,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		items = v11 or {},
		renderItem = props.renderItem
	}))
	return createElement(frame, v14, children)
end

return SponsoredItems
