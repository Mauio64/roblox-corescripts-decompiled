local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local React = require(GameTileParent.React)
local useDesignTokens = require(GameTileParent.Style).useDesignTokens
local UIBlox = require(GameTileParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(GameTileParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
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

local function GameTileView(t1: {[any]: any}) -- line: 92
	-- upvalues: useDesignTokens (copy), useTokens (copy), GameTileViewConfig (copy), FFlagRenameDeprecatedUIBloxTokens (copy), useCursor (copy), FFlagLuaAppMigrateGameTileHoverFixes (copy), React (copy), FFlagLuaAppGameTileInteractionFeedback (copy), ZoomAnimatedFrame (copy), ImageSetLabel (copy), Images (copy), FFlagLuaAppHomePageFirstImageLoadObserver (copy), LoadableImage (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), RightAlignedButtonWrapper (copy)
	local v21 = useDesignTokens()
	local v22 = if not t1.isUnifiedGameTile then nil else t1.numLinesForTitle or 1
	local v23 = t1.numLinesForMetadata or 1
	local textSizeOffset = t1.textSizeOffset
	local v25 = useTokens()
	local v26 = GameTileViewConfig.getElementSizes(v21, textSizeOffset, if not t1.isUnifiedGameTile then nil else v22, if not t1.isUnifiedGameTile then nil else v25, not not t1.isUnifiedGameTile or nil, v23)
	local v27 = if not v25 or not t1.isUnifiedGameTile then if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Space_100 else v21.Size.Size_200 else v25.Radius.Medium
	local uDim = UDim.new(0, v27)
	local v29 = useCursor(uDim)
	local v30 = if not v25 or not t1.isUnifiedGameTile then if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Typography.Subheader else v21.Typography.TitleLarge else v25.Typography.TitleMedium
	local FontSize = v30.FontSize
	local v32 = if not v25 or not t1.isUnifiedGameTile then if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Color.Text.Emphasis else v21.Color.Content.Emphasis else v25.Color.Content.Emphasis
	local v33 = if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Space_50 else v21.Size.Size_100
	local v34 = if not t1.isUnifiedGameTile then if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Space_150 else v21.Size.Size_300 else t1.hoverPadding or if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Space_150 else v21.Size.Size_300
	local v35 = if not t1.hidePlayButton then v26.playButtonHeight else 0
	local v36 = if not t1.isUnifiedGameTile then not t1.isContained and 0 or if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Space_150 else v21.Size.Size_300 else not t1.isContained and 0 or (t1.containmentSidePadding or v25.Padding.Medium)
	local v37 = if not t1.hidePlayButton and (not t1.isContained or not t1.isUnifiedGameTile) then if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Space_150 else v21.Size.Size_300 else 0
	local isHovered = t1.isHovered
	local v39 = FFlagLuaAppMigrateGameTileHoverFixes and (isHovered and t1.isUnifiedGameTile)
	local uDim2 = UDim.new(1, -if not t1.isUnifiedGameTile then ((if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Space_150 else v21.Size.Size_300)) + v36 else v36)
	local v41 = t1.Size or UDim2.fromScale(1, 1)

	if isHovered then
		v41 += UDim2.fromOffset(v34 * 2, v34 * 2)
	end

	local v42 = GameTileViewConfig.getFooterHeight(v21, t1.isContained, t1.footerMetadata == nil, t1.title == nil, textSizeOffset, t1.extraFooterSpace, v22, v25, t1.isUnifiedGameTile, t1.numLinesForMetadata)
	local v43 = not t1.title and not t1.footerMetadata and 0 or v26.footerTopPadding
	local v44 = (not t1.title or not t1.footerMetadata) and 0 or v26.paddingAboveMetadata
	local v45 = not t1.title and 0 or v26.titleHeight
	local u46 = React.useRef(false)
	local v47 = React.useCallback(function(...) -- line: 196
		-- upvalues: u46 (ref), FFlagLuaAppGameTileInteractionFeedback (copy), t1 (copy)
		u46.current = false

		if FFlagLuaAppGameTileInteractionFeedback and t1.onGuiStateChanged then
			t1.onGuiStateChanged(...)
		end
	end, { t1.onGuiStateChanged })
	local v48 = React.useCallback(function() -- line: 203
		-- upvalues: t1 (copy), u46 (ref)
		if t1.onTouchLongPress and not t1.isDisabled then
			local current = u46.current

			u46.current = true

			if current == false then
				t1.onTouchLongPress()
			end
		end
	end, {
		t1.onTouchLongPress,
		t1.isDisabled
	})
	local v49 = React.useCallback(function() -- line: 213
		-- upvalues: u46 (ref), t1 (copy)
		if u46.current then
			u46.current = false

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
		expansionOffsetX = v33 * 2,
		expansionOffsetTop = v33,
		expansionOffsetBottom = v35 + v37 + ((if not t1.hidePlayButton then v33 else 0)) / (t1.imageAspectRatio or 1) + v33 + ((not t1.hideMetadata or not t1.footerMetadata) and 0 or v26.metadataHeight),
		reducedMotion = t1.reducedMotion
	}, {
		HoverShadow = isHovered and React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			ZIndex = -1,
			Position = UDim2.new(0.5, 0, 0.5, 2),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, v34 + 18, 1, v34 + 20),
			Image = Images["component_assets/dropshadow_56_8"],
			ImageColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Color.Common.DropShadow else v21.Color.Common.Shadow)).Color3,
			ImageTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Color.Common.DropShadow else v21.Color.Common.Shadow)).Transparency,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(35, 35, 37, 37)
		}) or nil,
		GameTileContent = React.createElement("TextButton", {
			SelectionOrder = t1.SelectionOrder,
			ref = t1.forwardRef,
			Size = v41,
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			SelectionImageObject = v29,
			Active = not t1.isDisabled,
			[React.Change.GuiState] = v47,
			[React.Event.Activated] = v49,
			[React.Event.SelectionGained] = t1.onSelectionGained,
			[React.Event.SelectionLost] = t1.onSelectionLost,
			[React.Event.TouchLongPress] = v48,
			ClipsDescendants = false,
			Text = "",
			BackgroundTransparency = if not v25 or not t1.isUnifiedGameTile then isHovered and ((if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Color.BackgroundUi.Default else v21.Color.Surface.Surface_300)).Transparency or 1 else isHovered and v25.Color.Surface.Surface_100.Transparency or 1,
			BackgroundColor3 = if not v25 or not t1.isUnifiedGameTile then ((if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Color.BackgroundUi.Default else v21.Color.Surface.Surface_300)).Color3 else v25.Color.Surface.Surface_100.Color3,
			AutoButtonColor = false,
			Selectable = t1.Selectable,
			[React.Tag] = "data-testid=--game-tile"
		}, {
			UIPadding = isHovered and React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v34),
				PaddingTop = UDim.new(0, v34),
				PaddingRight = UDim.new(0, v34),
				PaddingBottom = UDim.new(0, v34)
			}) or nil,
			UICorner = React.createElement("UICorner", {
				CornerRadius = if not FFlagLuaAppMigrateGameTileHoverFixes or not t1.isUnifiedGameTile then uDim + UDim.new(0, v34) else uDim
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
					Size = UDim2.new(1, 0, 1, (not t1.isContained or v39) and 0 or v27),
					cornerRadius = uDim,
					ScaleType = if not t1.isContained or v39 then nil else Enum.ScaleType.Tile,
					TileSize = if not t1.isContained or v39 then nil else UDim2.new(1, 0, 1, -v27),
					onLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t1.onTileImageLoaded
				}) else t1.thumbnailComponent,
				ContainedBackgroundTop = if not t1.isContained or v39 then nil else React.createElement("Frame", {
					BackgroundTransparency = 0,
					ZIndex = -1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, v42 - v27),
					Position = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = if not t1.isUnifiedGameTile or not v25 then ((if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Color.BackgroundUi.Default else v21.Color.Surface.Surface_300)).Color3 else v25.Color.Surface.Surface_100.Color3
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
				Size = UDim2.new(1, 0, 0, v42),
				BackgroundTransparency = not t1.isContained and 1 or 0,
				BackgroundColor3 = if not v25 or not t1.isUnifiedGameTile then ((if not FFlagRenameDeprecatedUIBloxTokens then v21.Semantic.Color.BackgroundUi.Default else v21.Color.Surface.Surface_300)).Color3 else v25.Color.Surface.Surface_100.Color3
			}, {
				UICorner = if not t1.isContained then nil else React.createElement("UICorner", {
					CornerRadius = uDim
				}),
				TextWrapper = React.createElement(RightAlignedButtonWrapper, {
					Button = t1.rightCornerButton,
					Padding = UDim.new(0, if not t1.isContained then if not FFlagRenameDeprecatedUIBloxTokens then v21.Global.Space_150 else v21.Size.Size_300 else 0),
					Content = React.createElement(React.Fragment, nil, {
						Title = t1.title and React.createElement("TextLabel", {
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							Position = UDim2.new(0, v36, 0, v43),
							Size = UDim2.new(1, -2 * v36, 0, v45),
							Text = t1.title,
							Font = v30.Font,
							TextSize = FontSize,
							TextTransparency = v32.Transparency,
							TextColor3 = v32.Color3,
							TextWrapped = not not v22 and (not not t1.isUnifiedGameTile and v22 > 1),
							TextTruncate = Enum.TextTruncate.SplitWord,
							TextXAlignment = Enum.TextXAlignment.Left,
							TextYAlignment = if not t1.isUnifiedGameTile then Enum.TextYAlignment.Center else Enum.TextYAlignment.Top
						}) or nil,
						Metadata = t1.footerMetadata and React.createElement("Frame", {
							ClipsDescendants = false,
							BackgroundTransparency = 1,
							LayoutOrder = 5,
							Position = UDim2.new(0, v36, 0, v45 + v43 + v44),
							Size = UDim2.new(uDim2, UDim.new(0, v26.metadataHeight))
						}, {
							MetadataContent = t1.footerMetadata
						}),
						ExtraContent = t1.extraFooterContent and (t1.extraFooterSpace and React.createElement("Frame", {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, -v36 * 2, 0, t1.extraFooterSpace),
							Position = UDim2.new(0, v36, 0, v45 + v43 + v44 + v26.metadataHeight)
						}, { t1.extraFooterContent }))
					})
				})
			}) or nil,
			PaddingAboveActionRow = isHovered and React.createElement("Frame", {
				LayoutOrder = 6,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, v37)
			}) or nil,
			ActionRow = isHovered and React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 7,
				Size = UDim2.new(1, 0, 0, v35)
			}, {
				Content = t1.hoverActionRow
			}) or nil
		})
	})
end

return GameTileView
