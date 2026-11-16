local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local UIBlox = require(parent.UIBlox)

local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local LoadableImage = UIBlox.App.Loading.LoadableImage
local useCursor = UIBlox.App.SelectionCursor.useCursor

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local RightAlignedButtonWrapper = require(GameTile.Footer.RightAlignedButtonWrapper)
local ZoomAnimatedFrame = require(GameTile.ZoomAnimatedFrame)
local GameTileViewConfig = require(GameTile.GameTileViewConfig)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppMigrateGameTileHoverFixes = SharedFlags2.FFlagLuaAppMigrateGameTileHoverFixes

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppGameViewTileBackgroundColorOverride = SharedFlags3.FFlagLuaAppGameViewTileBackgroundColorOverride

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags4.FFlagLuaAppHomePageFirstImageLoadObserver

local function GameTileView(props)
	local v = useDesignTokens()
	local numLinesForTitle = props.isUnifiedGameTile and (props.numLinesForTitle or 1) or nil
	local numLinesForMetadata = props.numLinesForMetadata or 1
	local textSizeOffset = props.textSizeOffset
	local v2 = useTokens()

	local getElementSizes = GameTileViewConfig.getElementSizes
	local v3

	if props.isUnifiedGameTile then
		v3 = numLinesForTitle
	end

	local v4

	if props.isUnifiedGameTile then
		v4 = v2
	end

	local elementSizes = getElementSizes(
		v,
		textSizeOffset,
		v3,
		v4,
		props.isUnifiedGameTile and true or nil,
		numLinesForMetadata
	)
	local v5

	if v2 and props.isUnifiedGameTile then
		v5 = v2.Radius.Medium
	else
		v5 = v.Size.Size_200
	end

	local udim = UDim.new(0, v5)
	local selectionImageObject = useCursor(udim)
	local v6

	if v2 and props.isUnifiedGameTile then
		v6 = v2.Typography.TitleMedium
	else
		v6 = v.Typography.TitleLarge
	end

	local fontSize = v6.FontSize
	local emphasis

	if v2 and props.isUnifiedGameTile then
		emphasis = v2.Color.Content.Emphasis
	else
		emphasis = v.Color.Content.Emphasis
	end

	local size_100 = v.Size.Size_100
	local v7

	if props.isUnifiedGameTile then
		v7 = props.hoverPadding or v.Size.Size_300
	else
		v7 = v.Size.Size_300
	end

	local v8 = props.hidePlayButton and 0 or elementSizes.playButtonHeight
	local v9

	if props.isUnifiedGameTile then
		v9 = not props.isContained and 0 or props.containmentSidePadding or v2.Padding.Medium
	else
		v9 = not props.isContained and 0 or v.Size.Size_300
	end

	local v10 = (props.hidePlayButton or props.isContained and props.isUnifiedGameTile) and 0 or v.Size.Size_300

	local isHovered = props.isHovered

	local isUnifiedGameTile = FFlagLuaAppMigrateGameTileHoverFixes and isHovered and props.isUnifiedGameTile
	local v11

	if props.isUnifiedGameTile then
		v11 = v9
	else
		v11 = v.Size.Size_300 + v9
	end

	local udim2 = UDim.new(1, -v11)

	local size = props.Size or UDim2.fromScale(1, 1)

	if isHovered then
		size += UDim2.fromOffset(v7 * 2, v7 * 2)
	end

	local footerHeight = GameTileViewConfig.getFooterHeight(
		v,
		props.isContained,
		props.footerMetadata == nil,
		props.title == nil,
		textSizeOffset,
		props.extraFooterSpace,
		numLinesForTitle,
		v2,
		props.isUnifiedGameTile,
		props.numLinesForMetadata
	)

	local v12 = not (props.title or props.footerMetadata) and 0 or elementSizes.footerTopPadding
	local v13 = not (props.title and props.footerMetadata) and 0 or elementSizes.paddingAboveMetadata
	local v14 = not props.title and 0 or elementSizes.titleHeight
	local transparency

	if v2 and props.isUnifiedGameTile then
		transparency = isHovered and v2.Color.Surface.Surface_100.Transparency or 1
	else
		transparency = isHovered and v.Color.Surface.Surface_300.Transparency or 1
	end

	local color3

	if v2 and props.isUnifiedGameTile then
		color3 = v2.Color.Surface.Surface_100.Color3
	else
		color3 = v.Color.Surface.Surface_300.Color3
	end

	if FFlagLuaAppGameViewTileBackgroundColorOverride and props.backgroundStyle then
		transparency = isHovered and props.backgroundStyle.Transparency or 1
		color3 = props.backgroundStyle.Color3
	end

	local ref = React.useRef(false)

	local v15 = React.useCallback(function(...)
		ref.current = false

		if props.onGuiStateChanged then
			props.onGuiStateChanged(...)
		end
	end, { props.onGuiStateChanged })

	local v16 = React.useCallback(function()
		if props.onTouchLongPress and not props.isDisabled then
			local current = ref.current
			ref.current = true

			if current == false then
				props.onTouchLongPress()
			end
		end
	end, { props.onTouchLongPress, props.isDisabled })

	local v17 = React.useCallback(function()
		if ref.current then
			ref.current = false
		elseif props.onActivated and not props.isDisabled then
			props.onActivated()
		end
	end, { props.onActivated, props.isDisabled })
	local v18

	if FFlagLuaAppContinueSortInstantPlay then
		v18 = React.useCallback(function()
			if ref.current then
				ref.current = false
			elseif props.onMetadataActivated and not props.isDisabled then
				props.onMetadataActivated()
			end
		end, { props.onMetadataActivated, props.isDisabled })
	end

	local v19

	if FFlagLuaAppContinueSortInstantPlay then
		v19 = props.isTouchPreferredInput and props.onMetadataActivated ~= nil
	end

	local createElement = React.createElement
	local v20 = {
		isZoomEnabled = isHovered,
		expansionOffsetX = size_100 * 2,
		expansionOffsetTop = size_100,
		expansionOffsetBottom = v8 + v10 + (props.hidePlayButton and 0 or size_100) / (props.imageAspectRatio or 1) + size_100 + (not (props.hideMetadata and props.footerMetadata) and 0 or elementSizes.metadataHeight),
		reducedMotion = props.reducedMotion
	}
	local hoverShadow

	if isHovered then
		hoverShadow = React.createElement(ImageSetLabel, {
			Position = UDim2.new(0.5, 0, 0.5, 2),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Size = UDim2.new(1, v7 + 18, 1, v7 + 20),
			Image = Images["component_assets/dropshadow_56_8"],
			ImageColor3 = v.Color.Common.Shadow.Color3,
			ImageTransparency = v.Color.Common.Shadow.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(35, 35, 37, 37),
			ZIndex = -1
		}) or nil
	end

	local createElement2 = React.createElement
	local v21 = {
		SelectionOrder = props.SelectionOrder,
		ref = props.forwardRef,
		Size = size,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		SelectionImageObject = selectionImageObject,
		Active = not props.isDisabled,
		[React.Change.GuiState] = v15,
		[React.Event.Activated] = v17,
		[React.Event.SelectionGained] = props.onSelectionGained,
		[React.Event.SelectionLost] = props.onSelectionLost,
		[React.Event.TouchLongPress] = v16,
		ClipsDescendants = false,
		Text = "",
		BackgroundTransparency = transparency,
		BackgroundColor3 = color3,
		AutoButtonColor = false,
		Selectable = props.Selectable,
		[React.Tag] = "data-testid=--game-tile"
	}
	local uiPadding

	if isHovered then
		uiPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v7),
				PaddingTop = UDim.new(0, v7),
				PaddingRight = UDim.new(0, v7),
				PaddingBottom = UDim.new(0, v7)
			})
			or nil
	end

	local createElement3 = React.createElement
	local cornerRadius

	if FFlagLuaAppMigrateGameTileHoverFixes and props.isUnifiedGameTile then
		cornerRadius = udim
	else
		cornerRadius = udim + UDim.new(0, v7)
	end

	local children = {
		UIPadding = uiPadding,
		UICorner = createElement3("UICorner", { CornerRadius = cornerRadius }),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		ThumbnailFrame = 0,
		BottomContent = 0,
		PaddingAboveActionRow = 0,
		ActionRow = 0
	}

	local createElement4 = React.createElement
	local v22 = {
		[React.Tag] = FFlagLuaAppHomePageFirstImageLoadObserver and "observed-image" or nil,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		LayoutOrder = 1,
		ZIndex = -1
	}
	local thumbnail

	if props.thumbnailComponent then
		thumbnail = props.thumbnailComponent
	else
		local createElement5 = React.createElement
		local v23 = {
			BackgroundTransparency = 1,
			Image = props.image,
			Size = UDim2.new(1, 0, 1, (not props.isContained or isUnifiedGameTile) and 0 or v5),
			cornerRadius = udim,
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true,
			ZIndex = -2,
			ScaleType = 0,
			TileSize = 0
		}
		local scaleType

		if props.isContained and not isUnifiedGameTile then
			scaleType = Enum.ScaleType.Tile
		end

		v23.ScaleType = scaleType
		local tileSize

		if props.isContained and not isUnifiedGameTile then
			tileSize = UDim2.new(1, 0, 1, -v5)
		end

		v23.TileSize = tileSize
		thumbnail = createElement5(LoadableImage, v23)
	end

	local containedBackgroundTop

	if props.isContained and not isUnifiedGameTile then
		containedBackgroundTop = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, footerHeight - v5),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = 0,
			ZIndex = -1,
			BackgroundColor3 = color3,
			BorderSizePixel = 0
		})
	end

	children.ThumbnailFrame = createElement4("Frame", v22, {
		Thumbnail = thumbnail,
		ContainedBackgroundTop = containedBackgroundTop,
		UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = props.imageAspectRatio or 1
		}),
		ThumbnailOverlay = props.thumbnailOverlay,
		OverflowMenu = props.overflowMenu
	})

	local createElement5 = React.createElement
	local v23 = {
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		Size = UDim2.new(1, 0, 0, footerHeight),
		LayoutOrder = 2,
		BackgroundTransparency = props.isContained and 0 or 1,
		BackgroundColor3 = color3,
		BorderSizePixel = 0
	}
	local active

	if FFlagLuaAppContinueSortInstantPlay and v19 then
		active = not props.isDisabled
	end

	v23.Active = active

	local guiState = React.Change.GuiState

	if not (FFlagLuaAppContinueSortInstantPlay and v19) then
		v15 = nil
	end

	v23[guiState] = v15

	local touchTap = React.Event.TouchTap

	if not (FFlagLuaAppContinueSortInstantPlay and v19) then
		v18 = nil
	end

	v23[touchTap] = v18

	local touchLongPress = React.Event.TouchLongPress

	if not (FFlagLuaAppContinueSortInstantPlay and v19) then
		v16 = nil
	end

	v23[touchLongPress] = v16
	local uiCorner

	if props.isContained then
		uiCorner = React.createElement("UICorner", { CornerRadius = udim })
	end

	local createElement6 = React.createElement
	local v24 = {
		Button = props.rightCornerButton,
		Padding = UDim.new(0, props.isContained and 0 or v.Size.Size_300),
		Content = 0
	}
	local createElement7 = React.createElement
	local fragment = React.Fragment
	local title

	if props.title then
		local createElement8 = React.createElement
		local v25 = {
			Position = UDim2.new(0, v9, 0, v12),
			Size = UDim2.new(1, -2 * v9, 0, v14),
			BackgroundTransparency = 1,
			Text = props.title,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextTransparency = 0,
			TextColor3 = 0,
			TextWrapped = 0,
			TextTruncate = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			LayoutOrder = 3
		}
		local font

		if not FoundationFontFaceMigration then
			font = v6.Font
		end

		v25.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(v6.Font)
		end

		v25.FontFace = fontFace

		v25.TextSize = fontSize
		v25.TextTransparency = emphasis.Transparency
		v25.TextColor3 = emphasis.Color3
		local textWrapped

		if numLinesForTitle and props.isUnifiedGameTile then
			textWrapped = numLinesForTitle > 1
		else
			textWrapped = false
		end

		v25.TextWrapped = textWrapped

		v25.TextTruncate = Enum.TextTruncate.SplitWord
		v25.TextXAlignment = Enum.TextXAlignment.Left
		local textYAlignment

		if props.isUnifiedGameTile then
			textYAlignment = Enum.TextYAlignment.Top
		else
			textYAlignment = Enum.TextYAlignment.Center
		end

		v25.TextYAlignment = textYAlignment
		title = createElement8("TextLabel", v25) or nil
	end

	v24.Content = createElement7(fragment, nil, {
		Title = title,
		Metadata = props.footerMetadata and React.createElement("Frame", {
			Position = UDim2.new(0, v9, 0, v14 + v12 + v13),
			Size = UDim2.new(udim2, UDim.new(0, elementSizes.metadataHeight)),
			ClipsDescendants = false,
			BackgroundTransparency = 1,
			LayoutOrder = 5
		}, { MetadataContent = props.footerMetadata }),
		ExtraContent = props.extraFooterContent and props.extraFooterSpace and React.createElement("Frame", {
			Size = UDim2.new(1, -v9 * 2, 0, props.extraFooterSpace),
			Position = UDim2.new(0, v9, 0, v14 + v12 + v13 + elementSizes.metadataHeight),
			BackgroundTransparency = 1
		}, { props.extraFooterContent })
	})
	children.BottomContent = createElement5("Frame", v23, {
			UICorner = uiCorner,
			TextWrapper = createElement6(RightAlignedButtonWrapper, v24)
		})
		or nil

	children.PaddingAboveActionRow = isHovered
		and React.createElement("Frame", {
			LayoutOrder = 6,
			Size = UDim2.fromOffset(0, v10),
			BackgroundTransparency = 1
		})
		or nil

	children.ActionRow = isHovered
		and React.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, v8), BackgroundTransparency = 1, LayoutOrder = 7 },
			{ Content = props.hoverActionRow }
		)
		or nil
	return createElement(ZoomAnimatedFrame, v20, {
		HoverShadow = hoverShadow,
		GameTileContent = createElement2("TextButton", v21, children)
	})
end

return GameTileView
