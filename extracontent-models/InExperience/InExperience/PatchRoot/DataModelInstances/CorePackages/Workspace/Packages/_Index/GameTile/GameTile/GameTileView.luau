local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local useDesignTokens = require(GameTileParent.Style).useDesignTokens
local UIBlox = require(GameTileParent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local LoadableImage = UIBlox.App.Loading.LoadableImage
local useCursor = UIBlox.App.SelectionCursor.useCursor
local RightAlignedButtonWrapper = require(GameTile.Footer.RightAlignedButtonWrapper)
local ZoomAnimatedFrame = require(GameTile.ZoomAnimatedFrame)
local GameTileViewConfig = require(GameTile.GameTileViewConfig)
local FFlagLuaAppGameTileInteractionFeedback = require(GameTileParent.SharedFlags).FFlagLuaAppGameTileInteractionFeedback
local FFlagLuaAppMigrateGameTileHoverFixes = require(GameTileParent.SharedFlags).FFlagLuaAppMigrateGameTileHoverFixes
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = require(GameTileParent.SharedFlags).FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppHomePageFirstImageLoadObserver = require(GameTileParent.SharedFlags).FFlagLuaAppHomePageFirstImageLoadObserver
local useTokens = require(GameTileParent.Foundation).Hooks.useTokens

local function GameTileView(t1: {[any]: any}) -- line: 90
	-- upvalues: useDesignTokens (copy), useTokens (copy), GameTileViewConfig (copy), useCursor (copy), FFlagLuaAppMigrateGameTileHoverFixes (copy), React (copy), FFlagLuaAppGameTileInteractionFeedback (copy), ZoomAnimatedFrame (copy), ImageSetLabel (copy), Images (copy), FFlagLuaAppHomePageFirstImageLoadObserver (copy), LoadableImage (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), RightAlignedButtonWrapper (copy)
	local v20 = useDesignTokens()
	local v21 = if not t1.isUnifiedGameTile then nil else t1.numLinesForTitle or 1
	local v22 = t1.numLinesForMetadata or 1
	local textSizeOffset = t1.textSizeOffset
	local v24 = useTokens()
	local v25 = GameTileViewConfig.getElementSizes(v20, textSizeOffset, if not t1.isUnifiedGameTile then nil else v21, if not t1.isUnifiedGameTile then nil else v24, not not t1.isUnifiedGameTile or nil, v22)
	local v26 = if not v24 or not t1.isUnifiedGameTile then v20.Size.Size_200 else v24.Radius.Medium
	local uDim = UDim.new(0, v26)
	local v28 = useCursor(uDim)
	local v29 = if not v24 or not t1.isUnifiedGameTile then v20.Typography.TitleLarge else v24.Typography.TitleMedium
	local FontSize = v29.FontSize
	local v31 = if not v24 or not t1.isUnifiedGameTile then v20.Color.Content.Emphasis else v24.Color.Content.Emphasis
	local Size_100 = v20.Size.Size_100
	local v33 = if not t1.isUnifiedGameTile then v20.Size.Size_300 else t1.hoverPadding or v20.Size.Size_300
	local v34 = if not t1.hidePlayButton then v25.playButtonHeight else 0
	local v35 = if not t1.isUnifiedGameTile then not t1.isContained and 0 or v20.Size.Size_300 else not t1.isContained and 0 or (t1.containmentSidePadding or v24.Padding.Medium)
	local v36 = if not t1.hidePlayButton and (not t1.isContained or not t1.isUnifiedGameTile) then v20.Size.Size_300 else 0
	local isHovered = t1.isHovered
	local v38 = FFlagLuaAppMigrateGameTileHoverFixes and (isHovered and t1.isUnifiedGameTile)
	local uDim2 = UDim.new(1, -if not t1.isUnifiedGameTile then v20.Size.Size_300 + v35 else v35)
	local v40 = t1.Size or UDim2.fromScale(1, 1)

	if isHovered then
		v40 += UDim2.fromOffset(v33 * 2, v33 * 2)
	end

	local v41 = GameTileViewConfig.getFooterHeight(v20, t1.isContained, t1.footerMetadata == nil, t1.title == nil, textSizeOffset, t1.extraFooterSpace, v21, v24, t1.isUnifiedGameTile, t1.numLinesForMetadata)
	local v42 = not t1.title and not t1.footerMetadata and 0 or v25.footerTopPadding
	local v43 = (not t1.title or not t1.footerMetadata) and 0 or v25.paddingAboveMetadata
	local v44 = not t1.title and 0 or v25.titleHeight
	local u45 = React.useRef(false)
	local v46 = React.useCallback(function(...) -- line: 178
		-- upvalues: u45 (ref), FFlagLuaAppGameTileInteractionFeedback (copy), t1 (copy)
		u45.current = false

		if FFlagLuaAppGameTileInteractionFeedback and t1.onGuiStateChanged then
			t1.onGuiStateChanged(...)
		end
	end, { t1.onGuiStateChanged })
	local v47 = React.useCallback(function() -- line: 185
		-- upvalues: t1 (copy), u45 (ref)
		if t1.onTouchLongPress and not t1.isDisabled then
			local current = u45.current

			u45.current = true

			if current == false then
				t1.onTouchLongPress()
			end
		end
	end, {
		t1.onTouchLongPress,
		t1.isDisabled
	})
	local v48 = React.useCallback(function() -- line: 195
		-- upvalues: u45 (ref), t1 (copy)
		if u45.current then
			u45.current = false

			return
		end

		if t1.onActivated and not t1.isDisabled then
			t1.onActivated()
		end
	end, {
		t1.onActivated,
		t1.isDisabled
	})

	return React.createElement(ZoomAnimatedFrame, {
		isZoomEnabled = isHovered,
		expansionOffsetX = Size_100 * 2,
		expansionOffsetTop = Size_100,
		expansionOffsetBottom = v34 + v36 + ((if not t1.hidePlayButton then Size_100 else 0)) / (t1.imageAspectRatio or 1) + Size_100 + ((not t1.hideMetadata or not t1.footerMetadata) and 0 or v25.metadataHeight),
		reducedMotion = t1.reducedMotion
	}, {
		HoverShadow = isHovered and React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ZIndex = -1,
			Position = UDim2.new(0.5, 0, 0.5, 2),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, v33 + 18, 1, v33 + 20),
			Image = Images["component_assets/dropshadow_56_8"],
			ImageColor3 = v20.Color.Common.Shadow.Color3,
			ImageTransparency = v20.Color.Common.Shadow.Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(35, 35, 37, 37)
		}) or nil,
		GameTileContent = React.createElement("TextButton", {
			SelectionOrder = t1.SelectionOrder,
			ref = t1.forwardRef,
			Size = v40,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			SelectionImageObject = v28,
			Active = not t1.isDisabled,
			[React.Change.GuiState] = v46,
			[React.Event.Activated] = v48,
			[React.Event.SelectionGained] = t1.onSelectionGained,
			[React.Event.SelectionLost] = t1.onSelectionLost,
			[React.Event.TouchLongPress] = v47,
			ClipsDescendants = false,
			Text = "",
			BackgroundTransparency = if not v24 or not t1.isUnifiedGameTile then isHovered and v20.Color.Surface.Surface_300.Transparency or 1 else isHovered and v24.Color.Surface.Surface_100.Transparency or 1,
			BackgroundColor3 = if not v24 or not t1.isUnifiedGameTile then v20.Color.Surface.Surface_300.Color3 else v24.Color.Surface.Surface_100.Color3,
			AutoButtonColor = false,
			Selectable = t1.Selectable,
			[React.Tag] = "data-testid=--game-tile"
		}, {
			UIPadding = isHovered and React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v33),
				PaddingTop = UDim.new(0, v33),
				PaddingRight = UDim.new(0, v33),
				PaddingBottom = UDim.new(0, v33)
			}) or nil,
			UICorner = React.createElement("UICorner", {
				CornerRadius = if not FFlagLuaAppMigrateGameTileHoverFixes or not t1.isUnifiedGameTile then uDim + UDim.new(0, v33) else uDim
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ThumbnailFrame = React.createElement("Frame", {
				[React.Tag] = if not FFlagLuaAppHomePageFirstImageLoadObserver then nil else "observed-image",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				LayoutOrder = 1,
				ZIndex = -1
			}, {
				Thumbnail = if not t1.thumbnailComponent then React.createElement(LoadableImage, {
					BackgroundTransparency = 1,
					showFailedStateWhenLoadingFailed = true,
					useShimmerAnimationWhileLoading = true,
					ZIndex = -2,
					Image = t1.image,
					Size = UDim2.new(1, 0, 1, (not t1.isContained or v38) and 0 or v26),
					cornerRadius = uDim,
					ScaleType = if not t1.isContained or v38 then nil else Enum.ScaleType.Tile,
					TileSize = if not t1.isContained or v38 then nil else UDim2.new(1, 0, 1, -v26),
					onLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t1.onTileImageLoaded
				}) else t1.thumbnailComponent,
				ContainedBackgroundTop = if not t1.isContained or v38 then nil else React.createElement("Frame", {
					BackgroundTransparency = 0,
					ZIndex = -1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, v41 - v26),
					Position = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = if not t1.isUnifiedGameTile or not v24 then v20.Color.Surface.Surface_300.Color3 else v24.Color.Surface.Surface_100.Color3
				}),
				UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
					AspectRatio = t1.imageAspectRatio or 1
				}),
				ThumbnailOverlay = t1.thumbnailOverlay,
				OverflowMenu = t1.overflowMenu
			}),
			BottomContent = React.createElement("Frame", {
				LayoutOrder = 2,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, v41),
				BackgroundTransparency = not t1.isContained and 1 or 0,
				BackgroundColor3 = if not v24 or not t1.isUnifiedGameTile then v20.Color.Surface.Surface_300.Color3 else v24.Color.Surface.Surface_100.Color3
			}, {
				UICorner = if not t1.isContained then nil else React.createElement("UICorner", {
					CornerRadius = uDim
				}),
				TextWrapper = React.createElement(RightAlignedButtonWrapper, {
					Button = t1.rightCornerButton,
					Padding = UDim.new(0, if not t1.isContained then v20.Size.Size_300 else 0),
					Content = React.createElement(React.Fragment, nil, {
						Title = t1.title and React.createElement("TextLabel", {
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							Position = UDim2.new(0, v35, 0, v42),
							Size = UDim2.new(1, -2 * v35, 0, v44),
							Text = t1.title,
							Font = v29.Font,
							TextSize = FontSize,
							TextTransparency = v31.Transparency,
							TextColor3 = v31.Color3,
							TextWrapped = not not v21 and (not not t1.isUnifiedGameTile and v21 > 1),
							TextTruncate = Enum.TextTruncate.SplitWord,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = if not t1.isUnifiedGameTile then Enum.TextYAlignment.Center else Enum.TextYAlignment.Top
						}) or nil,
						Metadata = t1.footerMetadata and React.createElement("Frame", {
							ClipsDescendants = false,
							BackgroundTransparency = 1,
							LayoutOrder = 5,
							Position = UDim2.new(0, v35, 0, v44 + v42 + v43),
							Size = UDim2.new(uDim2, UDim.new(0, v25.metadataHeight))
						}, {
							MetadataContent = t1.footerMetadata
						}),
						ExtraContent = t1.extraFooterContent and (t1.extraFooterSpace and React.createElement("Frame", {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -v35 * 2, 0, t1.extraFooterSpace),
							Position = UDim2.new(0, v35, 0, v44 + v42 + v43 + v25.metadataHeight)
						}, { t1.extraFooterContent }))
					})
				})
			}) or nil,
			PaddingAboveActionRow = isHovered and React.createElement("Frame", {
				LayoutOrder = 6,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, v36)
			}) or nil,
			ActionRow = isHovered and React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 7,
				Size = UDim2.new(1, 0, 0, v34)
			}, {
				Content = t1.hoverActionRow
			}) or nil
		})
	})
end

return GameTileView
