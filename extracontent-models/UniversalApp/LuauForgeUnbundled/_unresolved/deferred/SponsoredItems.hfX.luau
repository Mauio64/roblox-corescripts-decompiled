local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useSelectedTheme = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useSelectedTheme
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module = require("@luauforge/bundled/gxM")
local iconWithTooltip = require("@game/CorePackages/Workspace/Packages/AppBlox").IconWithTooltip
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local Foundation = require(CorePackages.Packages.Foundation)

local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local grid = require("@luauforge/deferred/gPt").GridComponents.Grid
local getUseSelectorDeepEquals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.getUseSelectorDeepEquals

local module2 = require("@luauforge/bundled/dPN")

local module3 = require("@luauforge/deferred/hfY")
local module4 = require("@luauforge/deferred/hfZ")

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
	local v12 = font.BaseSize * font.Header2.RelativeSize

	local theme = v5.Theme
	local v13 = if v6 then theme.BackgroundMuted else theme.BackgroundContrast

	return React.createElement(RoactGamepad.Focusable.Frame, {
		Size = UDim2.new(1, widgetListHorizontalMargin * 2, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = v13.Transparency,
		BackgroundColor3 = v13.Color,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
		onFocusGained = props.moveFocusToColumn
	}, {
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
		SponsoredLabel = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1
			},
			{
				SponsoredUIListLayout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, v5.Tokens.Size.Size_100),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				SponsoredTitle = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					FontFace = normalizeFontFace(v8.Typography.BodyLarge.Font),
					Text = v7.sponsored,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextWrapped = true,
					TextSize = v12,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextColor3 = theme.TextMuted.Color,
					LayoutOrder = 1
				}),
				SponsoredTooltip = React.createElement(iconWithTooltip, {
					tooltipOrientation = tooltipOrientation.Right,
					onActivateTooltip = props.onActivateTooltipCallback,
					anchorPoint = Vector2.new(1, 0),
					layoutOrder = 2,
					hoverText = v7.sponsoredDisclosure,
					triggerPointName = "SponsoredTooltip",
					supportTenFootUi = true,
					supportVR = true
				})
			}
		),
		GridView = React.createElement(RoactGamepad.Focusable.Frame, {
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
	})
end

return SponsoredItems
