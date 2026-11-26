local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style").useDesignTokens
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/UIBlox")

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local loadableImage = UIBlox.App.Loading.LoadableImage
local useCursor = UIBlox.App.SelectionCursor.useCursor

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local RightAlignedButtonWrapper = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/Footer/RightAlignedButtonWrapper")
local ZoomAnimatedFrame = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/ZoomAnimatedFrame")
local GameTileViewConfig = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileViewConfig")
local fFlagLuaAppContinueSortInstantPlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppContinueSortInstantPlay
local fFlagLuaAppMigrateGameTileHoverFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppMigrateGameTileHoverFixes

local fFlagLuaAppGameViewTileBackgroundColorOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppGameViewTileBackgroundColorOverride

local fFlagLuaAppHomePageFirstImageLoadObserver = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppHomePageFirstImageLoadObserver

local function GameTileView(props)
	local v5 = useDesignTokens()
	local numLinesForTitle = props.isUnifiedGameTile and (props.numLinesForTitle or 1) or nil
	local numLinesForMetadata = props.numLinesForMetadata or 1
	local textSizeOffset = props.textSizeOffset
	local v6 = useTokens()

	local getElementSizes = GameTileViewConfig.getElementSizes

	local v7 = if props.isUnifiedGameTile then numLinesForTitle else nil
	local v8 = if props.isUnifiedGameTile then v6 else nil
	local elementSizes = getElementSizes(
		v5,
		textSizeOffset,
		v7,
		v8,
		props.isUnifiedGameTile and true or nil,
		numLinesForMetadata
	)

	local v9 = if v6 and props.isUnifiedGameTile then v6.Radius.Medium else v5.Size.Size_200
	local udim = UDim.new(0, v9)
	local v10 = useCursor(udim)
	local v11

	if v6 and props.isUnifiedGameTile then
		v11 = v6.Typography.TitleMedium
	else
		v11 = v5.Typography.TitleLarge
	end

	local fontSize = v11.FontSize
	local emphasis

	if v6 and props.isUnifiedGameTile then
		emphasis = v6.Color.Content.Emphasis
	else
		emphasis = v5.Color.Content.Emphasis
	end

	local size_100 = v5.Size.Size_100
	local v12

	if props.isUnifiedGameTile then
		v12 = props.hoverPadding or v5.Size.Size_300
	else
		v12 = v5.Size.Size_300
	end

	local v13 = props.hidePlayButton and 0 or elementSizes.playButtonHeight
	local v14

	if props.isUnifiedGameTile then
		v14 = not props.isContained and 0 or props.containmentSidePadding or v6.Padding.Medium
	else
		v14 = not props.isContained and 0 or v5.Size.Size_300
	end

	local v15 = (props.hidePlayButton or props.isContained and props.isUnifiedGameTile) and 0
		or v5.Size.Size_300

	local isHovered = props.isHovered

	local isUnifiedGameTile = fFlagLuaAppMigrateGameTileHoverFixes and isHovered and props.isUnifiedGameTile

	local newUDim = UDim.new

	local v17 = if props.isUnifiedGameTile then v14 else v5.Size.Size_300 + v14
	local udim2 = newUDim(1, -v17)

	local size = props.Size or UDim2.fromScale(1, 1)

	if isHovered then
		size += UDim2.fromOffset(v12 * 2, v12 * 2)
	end

	local footerHeight = GameTileViewConfig.getFooterHeight(
		v5,
		props.isContained,
		props.footerMetadata == nil,
		props.title == nil,
		textSizeOffset,
		props.extraFooterSpace,
		numLinesForTitle,
		v6,
		props.isUnifiedGameTile,
		props.numLinesForMetadata
	)

	local v18 = not (props.title or props.footerMetadata) and 0 or elementSizes.footerTopPadding
	local v19 = not (props.title and props.footerMetadata) and 0 or elementSizes.paddingAboveMetadata
	local v20 = not props.title and 0 or elementSizes.titleHeight
	local transparency

	if v6 and props.isUnifiedGameTile then
		transparency = isHovered and v6.Color.Surface.Surface_100.Transparency or 1
	else
		transparency = isHovered and v5.Color.Surface.Surface_300.Transparency or 1
	end

	local color3

	if v6 and props.isUnifiedGameTile then
		color3 = v6.Color.Surface.Surface_100.Color3
	else
		color3 = v5.Color.Surface.Surface_300.Color3
	end

	if fFlagLuaAppGameViewTileBackgroundColorOverride and props.backgroundStyle then
		transparency = isHovered and props.backgroundStyle.Transparency or 1
		color3 = props.backgroundStyle.Color3
	end

	local ref = React.useRef(false)

	local v21 = React.useCallback(function(...)
		ref.current = false

		if props.onGuiStateChanged then
			props.onGuiStateChanged(...)
		end
	end, { props.onGuiStateChanged })

	local v22 = React.useCallback(function()
		if props.onTouchLongPress and not props.isDisabled then
			local current = ref.current
			ref.current = true

			if current == false then
				props.onTouchLongPress()
			end
		end
	end, { props.onTouchLongPress, props.isDisabled })

	local v23 = React.useCallback(function()
		if ref.current then
			ref.current = false
		elseif props.onActivated and not props.isDisabled then
			props.onActivated()
		end
	end, { props.onActivated, props.isDisabled })
	local v24

	if fFlagLuaAppContinueSortInstantPlay then
		v24 = React.useCallback(function()
			if ref.current then
				ref.current = false
			elseif props.onMetadataActivated and not props.isDisabled then
				props.onMetadataActivated()
			end
		end, { props.onMetadataActivated, props.isDisabled })
	end

	local v25

	if fFlagLuaAppContinueSortInstantPlay then
		v25 = props.isTouchPreferredInput and props.onMetadataActivated ~= nil
	end

	local createElement = React.createElement
	local v27 = {
		isZoomEnabled = isHovered,
		expansionOffsetX = size_100 * 2,
		expansionOffsetTop = size_100,
		expansionOffsetBottom = v13 + v15 + (props.hidePlayButton and 0 or size_100) / (props.imageAspectRatio or 1) + size_100 + (not (props.hideMetadata and props.footerMetadata) and 0 or elementSizes.metadataHeight),
		reducedMotion = props.reducedMotion
	}

	local v29 = if isHovered then React.createElement(imageSetLabel, {
		Position = UDim2.new(0.5, 0, 0.5, 2),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, v12 + 18, 1, v12 + 20),
		Image = images["component_assets/dropshadow_56_8"],
		ImageColor3 = v5.Color.Common.Shadow.Color3,
		ImageTransparency = v5.Color.Common.Shadow.Transparency,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(35, 35, 37, 37),
		ZIndex = -1
	}) or nil else nil

	local createElement2 = React.createElement
	local v31 = {
		SelectionOrder = props.SelectionOrder,
		ref = props.forwardRef,
		Size = size,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		SelectionImageObject = v10,
		Active = not props.isDisabled,
		[React.Change.GuiState] = v21,
		[React.Event.Activated] = v23,
		[React.Event.SelectionGained] = props.onSelectionGained,
		[React.Event.SelectionLost] = props.onSelectionLost,
		[React.Event.TouchLongPress] = v22,
		ClipsDescendants = false,
		Text = "",
		BackgroundTransparency = transparency,
		BackgroundColor3 = color3,
		AutoButtonColor = false,
		Selectable = props.Selectable,
		[React.Tag] = "data-testid=--game-tile"
	}

	local v32 = if isHovered then React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, v12),
		PaddingTop = UDim.new(0, v12),
		PaddingRight = UDim.new(0, v12),
		PaddingBottom = UDim.new(0, v12)
	}) or nil else nil

	local createElement3 = React.createElement
	local v35 = if fFlagLuaAppMigrateGameTileHoverFixes and props.isUnifiedGameTile then udim else udim + UDim.new(0, v12)
	local children = {
		UIPadding = v32,
		UICorner = createElement3("UICorner", { CornerRadius = v35 }),
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
	local v37 = {
		[React.Tag] = fFlagLuaAppHomePageFirstImageLoadObserver and "observed-image" or nil,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		LayoutOrder = 1,
		ZIndex = -1
	}
	local v39

	if props.thumbnailComponent then
		v39 = props.thumbnailComponent
	else
		local createElement5 = React.createElement
		local v41 = {
			BackgroundTransparency = 1,
			Image = props.image,
			Size = UDim2.new(1, 0, 1, (not props.isContained or isUnifiedGameTile) and 0 or v9),
			cornerRadius = udim,
			showFailedStateWhenLoadingFailed = true,
			useShimmerAnimationWhileLoading = true,
			ZIndex = -2,
			ScaleType = 0,
			TileSize = 0
		}

		local v42 = if props.isContained and not isUnifiedGameTile then Enum.ScaleType.Tile else nil
		v41.ScaleType = v42

		local v43 = if props.isContained and not isUnifiedGameTile then UDim2.new(1, 0, 1, -v9) else nil
		v41.TileSize = v43
		v39 = createElement5(loadableImage, v41)
	end

	local v40 = if props.isContained and not isUnifiedGameTile then React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, footerHeight - v9),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundTransparency = 0,
		ZIndex = -1,
		BackgroundColor3 = color3,
		BorderSizePixel = 0
	}) else nil
	children.ThumbnailFrame = createElement4("Frame", v37, {
		Thumbnail = v39,
		ContainedBackgroundTop = v40,
		UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = props.imageAspectRatio or 1
		}),
		ThumbnailOverlay = props.thumbnailOverlay,
		OverflowMenu = props.overflowMenu
	})

	local createElement5 = React.createElement
	local v42 = {
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

	local v43 = if fFlagLuaAppContinueSortInstantPlay and v25 then not props.isDisabled else nil
	v42.Active = v43

	local guiState = React.Change.GuiState

	if not (fFlagLuaAppContinueSortInstantPlay and v25) then
		v21 = nil
	end

	v42[guiState] = v21

	local touchTap = React.Event.TouchTap

	if not (fFlagLuaAppContinueSortInstantPlay and v25) then
		v24 = nil
	end

	v42[touchTap] = v24

	local touchLongPress = React.Event.TouchLongPress

	if not (fFlagLuaAppContinueSortInstantPlay and v25) then
		v22 = nil
	end

	v42[touchLongPress] = v22

	local v45 = if props.isContained then React.createElement("UICorner", {
		CornerRadius = udim
	}) else nil

	local createElement6 = React.createElement
	local v47 = {
		Button = props.rightCornerButton,
		Padding = UDim.new(0, props.isContained and 0 or v5.Size.Size_300),
		Content = 0
	}
	local createElement7 = React.createElement
	local fragment = React.Fragment
	local v50

	if props.title then
		local createElement8 = React.createElement
		local v52 = {
			Position = UDim2.new(0, v14, 0, v18),
			Size = UDim2.new(1, -2 * v14, 0, v20),
			BackgroundTransparency = 1,
			Text = props.title,
			FontFace = normalizeFontFace(v11.Font),
			TextSize = fontSize,
			TextTransparency = emphasis.Transparency,
			TextColor3 = emphasis.Color3,
			TextWrapped = 0,
			TextTruncate = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			LayoutOrder = 3
		}
		local v53 = if numLinesForTitle and props.isUnifiedGameTile then numLinesForTitle > 1 else false
		v52.TextWrapped = v53

		v52.TextTruncate = Enum.TextTruncate.SplitWord
		v52.TextXAlignment = Enum.TextXAlignment.Left
		local v54 = if props.isUnifiedGameTile then Enum.TextYAlignment.Top else Enum.TextYAlignment.Center
		v52.TextYAlignment = v54
		v50 = createElement8("TextLabel", v52) or nil
	end

	v47.Content = createElement7(fragment, nil, {
		Title = v50,
		Metadata = props.footerMetadata and React.createElement("Frame", {
			Position = UDim2.new(0, v14, 0, v20 + v18 + v19),
			Size = UDim2.new(udim2, UDim.new(0, elementSizes.metadataHeight)),
			ClipsDescendants = false,
			BackgroundTransparency = 1,
			LayoutOrder = 5
		}, { MetadataContent = props.footerMetadata }),
		ExtraContent = props.extraFooterContent and props.extraFooterSpace and React.createElement("Frame", {
			Size = UDim2.new(1, -v14 * 2, 0, props.extraFooterSpace),
			Position = UDim2.new(0, v14, 0, v20 + v18 + v19 + elementSizes.metadataHeight),
			BackgroundTransparency = 1
		}, { props.extraFooterContent })
	})
	children.BottomContent = createElement5("Frame", v42, {
			UICorner = v45,
			TextWrapper = createElement6(RightAlignedButtonWrapper, v47)
		})
		or nil

	children.PaddingAboveActionRow = isHovered
		and React.createElement("Frame", {
			LayoutOrder = 6,
			Size = UDim2.fromOffset(0, v15),
			BackgroundTransparency = 1
		})
		or nil

	children.ActionRow = isHovered
		and React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, v13),
				BackgroundTransparency = 1,
				LayoutOrder = 7
			},
			{ Content = props.hoverActionRow }
		)
		or nil
	return createElement(ZoomAnimatedFrame, v27, {
		HoverShadow = v29,
		GameTileContent = createElement2("TextButton", v31, children)
	})
end

return GameTileView
