local ContentProvider = game:GetService("ContentProvider")
local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local Responsive = require(ServerDrivenUiParent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore
local useTokens = require(ServerDrivenUiParent.Foundation).Hooks.useTokens
local UIBlox = require(ServerDrivenUiParent.UIBlox)
local Cryo = require(ServerDrivenUiParent.Cryo)
local LoadableImage = UIBlox.App.Loading.LoadableImage
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local TextSize = require(ServerDrivenUiParent.TextSize)

require(ServerDrivenUiParent.SduiCoreSystem)

local HoldDetector = require(ServerDrivenUiParent.HoldToPlay).HoldDetector
local useTileHoldAction = require(script.Parent.useTileHoldAction)
local FFlagSduiTileDisableLegacyHover = require(ServerDrivenUi.Flags).FFlagSduiTileDisableLegacyHover
local FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone
local FFlagLuaAppHomePageFirstImageLoadObserver = require(ServerDrivenUiParent.SharedFlags).FFlagLuaAppHomePageFirstImageLoadObserver
local FFlagSduiTileBottomButton = require(ServerDrivenUiParent.SharedFlags).FFlagSduiTileBottomButton
local FFlagSduiTileHoldAction = require(ServerDrivenUiParent.SharedFlags).FFlagSduiTileHoldAction
local FFlagSduiExperienceDetailsSupport = require(ServerDrivenUiParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiTileTitleTextAlignment = require(ServerDrivenUiParent.SharedFlags).FFlagSduiTileTitleTextAlignment
local FFlagSduiTileImagePaddingInset = require(ServerDrivenUiParent.SharedFlags).FFlagSduiTileImagePaddingInset
local SduiTileInsetImage = require(script.Parent.SduiTileInsetImage)
local t1 = {}

local function maybeLayoutForButton(t2: {[any]: any}, p1, n1: number, n2: number, b1: boolean?) -- line: 137
	-- upvalues: React (copy), Cryo (copy)
	if p1 == nil or b1 then
		return t2
	end

	return {
		Content = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				HorizontalFlex = Enum.UIFlexAlignment.None,
				SortOrder = Enum.SortOrder.Name,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, n1 or 0),
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Bottom
			}),
			UIPadding = if not (n2 > 0) then nil else React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, n2),
				PaddingRight = UDim.new(0, n2),
				PaddingBottom = UDim.new(0, n2)
			}),
			LeftContent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(0, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY
			}, Cryo.Dictionary.join({
				UIFlexItem = React.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Shrink
				})
			}, t2)),
			RightContent = p1
		})
	}
end
local function SduiTile(t3: {[any]: any}) -- line: 190
	-- upvalues: React (copy), ContentProvider (copy), TextSize (copy), useTokens (copy), FFlagSduiTileBottomButton (copy), FFlagSduiExperienceDetailsSupport (copy), GetInputModeStore (copy), Responsive (copy), FFlagSduiTileHoldAction (copy), useTileHoldAction (copy), FFlagSduiTileDisableLegacyHover (copy), FFlagSduiTileImagePaddingInset (copy), SduiTileInsetImage (copy), FFlagLuaAppHomePageFirstImageLoadObserver (copy), ImageSetLabel (copy), LoadableImage (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), maybeLayoutForButton (copy), FFlagSduiTileTitleTextAlignment (copy), Cryo (copy), t1 (copy), HoldDetector (copy)
	local layoutOrder = t3.layoutOrder
	local anchorPoint = t3.anchorPoint
	local automaticSize = t3.automaticSize
	local size = t3.size
	local zIndex = t3.zIndex
	local position = t3.position
	local backgroundColor3 = t3.backgroundColor3
	local selectionOrder = t3.selectionOrder

	React.useLayoutEffect(function() -- line: 200
		-- upvalues: t3 (copy), ContentProvider (copy)
		if t3.image then
			task.spawn(function() -- line: 202
				-- upvalues: ContentProvider (copy), t3 (copy)
				ContentProvider:PreloadAsync({ t3.image })
			end)
		end
	end, { t3.image })

	local v41 = TextSize.getTextSizeStore(false).getTextSizeOffset(false)
	local v42 = useTokens()
	local v43 = if not t3.imageAspectRatio or t3.imageAspectRatio ~= 0 then t3.imageAspectRatio or 1 else 1
	local v44 = t3.titleLines or 1
	local v45 = t3.cornerRadius or v42.Radius.Medium
	local v46 = t3.titleFont or v42.Typography.TitleMedium
	local Emphasis = v42.Color.Content.Emphasis
	local v48 = math.ceil(v44 * (v46.LineHeight * v46.FontSize + v41))
	local v49 = t3.ctaButtonComponent ~= nil
	local v50 = nil
	local u51 = nil

	if FFlagSduiTileBottomButton then
		local v52

		v50, v52 = React.useState(false)
		u51 = v52
	end

	local isContained = t3.isContained
	local backgroundStyle, backgroundStyleColor3

	if FFlagSduiExperienceDetailsSupport and t3.backgroundStyle ~= nil then
		backgroundStyle = t3.backgroundStyle
		backgroundStyleColor3 = backgroundStyle.Color3
	else
		backgroundStyle = v42.Color.Surface.Surface_100
		backgroundStyleColor3 = backgroundColor3 or backgroundStyle.Color3
	end

	local v56 = t3.containmentPadding or v42.Padding.Small
	local v57, v58 = React.useState(false)
	local v59 = if t3.isHovered == nil then v57 else t3.isHovered
	local v60 = React.useCallback(function() -- line: 249
		-- upvalues: GetInputModeStore (copy), Responsive (copy), v58 (copy), t3 (copy)
		if GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Pointer then
			v58(true)

			if t3.onMouseEnter then
				t3.onMouseEnter()

				return
			end

			if t3.setCustomConditionState then
				t3.setCustomConditionState("hovered", true)
			end
		end
	end, {
		t3.onMouseEnter,
		t3.setCustomConditionState
	})
	local v61 = React.useCallback(function() -- line: 262
		-- upvalues: v58 (copy), t3 (copy)
		v58(false)

		if t3.onMouseLeave then
			t3.onMouseLeave()

			return
		end

		if t3.setCustomConditionState then
			t3.setCustomConditionState("hovered", false)
		end
	end, {
		t3.onMouseLeave,
		t3.setCustomConditionState
	})
	local v62 = React.useCallback(function() -- line: 271
		-- upvalues: t3 (copy)
		if t3.onSelectionGained then
			t3.onSelectionGained()

			return
		end

		if t3.setCustomConditionState then
			t3.setCustomConditionState("selected", true)
		end
	end, {
		t3.onSelectionGained,
		t3.setCustomConditionState
	})
	local v63 = React.useCallback(function() -- line: 279
		-- upvalues: t3 (copy)
		if t3.onSelectionLost then
			t3.onSelectionLost()

			return
		end

		if t3.setCustomConditionState then
			t3.setCustomConditionState("selected", false)
		end
	end, {
		t3.onSelectionLost,
		t3.setCustomConditionState
	})
	local v64 = nil

	if FFlagSduiTileHoldAction then
		v64 = useTileHoldAction(t3.holdActionConfig, t3.setGuiObject, t3.onActivated)
	end

	local v65 = nil
	local v66 = nil
	local v67 = nil
	local v68 = nil

	if not FFlagSduiTileDisableLegacyHover and t3.enableLegacyHoverState then
		v65 = v59
		v66 = t3.containmentPadding or v42.Padding.Medium
		v67 = if not v59 then nil else UDim2.new(1, v66 * 2, 1, v66 * 2)
		v68 = if not v59 then nil else UDim2.new(0, -v66, 0, -v66)
	end

	local v69 = not FFlagSduiExperienceDetailsSupport and 0 or backgroundStyle.Transparency
	local v70 = nil

	if FFlagSduiTileImagePaddingInset and t3.imagePadding ~= nil then
		v70 = React.createElement(SduiTileInsetImage, {
			image = t3.image,
			imageComponent = t3.imageComponent,
			imagePadding = t3.imagePadding,
			imageCornerRadius = t3.imageCornerRadius or 1000,
			cardCornerRadius = v45,
			isContained = isContained,
			backgroundStyle = t3.thumbnailBackgroundStyle
		})
	end

	return React.createElement("TextButton", {
		[React.Tag] = if not t3.testId then nil else `data-testid={ t3.testId }`,
		ref = if not v64 then t3.setGuiObject else v64.tileRef,
		Size = v67 or (size or UDim2.new(1, 0, 1, 0)),
		Position = v68 or position,
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		SelectionImageObject = t3.sduiContext.dependencies.cursors.tileCursor,
		Active = t3.isDisabled,
		[React.Event.Activated] = if not v64 then t3.onActivated else v64.onActivated,
		[React.Event.MouseEnter] = v60,
		[React.Event.MouseLeave] = v61,
		[React.Event.SelectionGained] = v62,
		[React.Event.SelectionLost] = v63,
		ClipsDescendants = false,
		Text = "",
		TextTransparency = 1,
		BackgroundTransparency = not isContained and not v65 and 1 or v69,
		AutoButtonColor = false,
		AutomaticSize = automaticSize or Enum.AutomaticSize.Y,
		BackgroundColor3 = backgroundStyleColor3,
		BorderSizePixel = 0,
		SelectionOrder = selectionOrder
	}, {
		UIPadding = if not FFlagSduiTileDisableLegacyHover then if not v65 then nil else React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v66),
			PaddingRight = UDim.new(0, v66),
			PaddingTop = UDim.new(0, v66)
		}) else nil,
		UICorner = if not isContained and (FFlagSduiTileDisableLegacyHover or not v65) then nil else React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v45)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v42.Gap.Medium)
		}),
		ImageFrame = React.createElement("Frame", {
			[React.Tag] = if not FFlagLuaAppHomePageFirstImageLoadObserver then nil else "observed-image",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1 / v43, 0),
			ZIndex = -1,
			LayoutOrder = 1,
			ClipsDescendants = not not isContained or nil,
			SizeConstraint = Enum.SizeConstraint.RelativeXX
		}, {
			BackgroundImage = if not t3.backgroundImageComponent then if not t3.backgroundImage then nil else React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				ZIndex = -3,
				Size = UDim2.new(1, 0, 1, 0),
				Image = t3.backgroundImage
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v45)
				})
			}) else t3.backgroundImageComponent,
			Thumbnail = if not v70 then if not t3.imageComponent then if not t3.image then nil else React.createElement(LoadableImage, {
				showFailedStateWhenLoadingFailed = true,
				useShimmerAnimationWhileLoading = true,
				ZIndex = -2,
				BackgroundColor3 = t3.thumbnailBackgroundStyle and t3.thumbnailBackgroundStyle.Color3 or nil,
				BackgroundTransparency = t3.thumbnailBackgroundStyle and t3.thumbnailBackgroundStyle.Transparency or 1,
				Image = t3.image,
				Size = UDim2.new(1, 0, 1, not isContained and 0 or v45),
				cornerRadius = UDim.new(0, v45),
				ScaleType = if not isContained then nil else Enum.ScaleType.Tile,
				TileSize = if not isContained then nil else UDim2.new(1, 0, 1, -v45),
				onLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t3.onTileImageLoaded
			}) else t3.imageComponent else v70,
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = v43 or 1
			}),
			ThumbnailOverlay = t3.thumbnailOverlayComponent,
			HoverOverlay = if not v59 or not not FFlagSduiTileBottomButton and v50 then nil else React.createElement("Frame", {
				BackgroundColor3 = v42.Color.State.Hover.Color3,
				BackgroundTransparency = v42.Color.State.Hover.Transparency,
				Size = UDim2.new(1, 0, 1, not isContained and 0 or v45)
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v45)
				})
			})
		}),
		BottomContent = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			ZIndex = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, (maybeLayoutForButton({
			UIPadding = if not isContained or v49 then nil else React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v56),
				PaddingRight = UDim.new(0, v56),
				PaddingBottom = UDim.new(0, v56)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.Name,
				HorizontalFlex = Enum.UIFlexAlignment.Fill
			}),
			["1_Title"] = if not t3.titleComponent then if not t3.titleText or t3.titleText == "" then nil else React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v48),
				Text = t3.titleText,
				Font = v46.Font,
				TextSize = v46.FontSize,
				TextTransparency = Emphasis.Transparency,
				TextColor3 = Emphasis.Color3,
				TextWrapped = v44 > 1,
				TextTruncate = Enum.TextTruncate.SplitWord,
				TextXAlignment = if not FFlagSduiTileTitleTextAlignment then Enum.TextXAlignment.Left else t3.titleTextXAlignment or Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				AutomaticSize = v49 and Enum.AutomaticSize.X or nil
			}) else t3.titleComponent,
			["2_Footer"] = if not t3.footerComponent then nil else t3.footerComponent,
			["3_BottomButton"] = if not FFlagSduiTileBottomButton or not t3.bottomButtonComponent then nil else React.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				[React.Event.MouseEnter] = function() -- line: 485
					-- upvalues: u51 (ref)
					if u51 then
						u51(true)
					end
				end,
				[React.Event.MouseLeave] = function() -- line: 490
					-- upvalues: u51 (ref)
					if u51 then
						u51(false)
					end
				end
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, t3.bottomButtonGap or v42.Gap.Small)
				}),
				Content = t3.bottomButtonComponent
			}),
			Z_3_ExtraOverflow = if not FFlagSduiTileDisableLegacyHover then if not v65 or not t3.renderLegacyHoverState then nil else React.createElement("Frame", {
				ZIndex = -1,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				ExtraOverflow = t3.renderLegacyHoverState(v66, backgroundStyleColor3, v45)
			}) else nil
		}, t3.ctaButtonComponent, v42.Gap.Small, not isContained and 0 or v56, v65))),
		ExtraChildren = if not t3.focusNavActionsComponent and not t3.children then nil else React.createElement(React.Fragment, nil, Cryo.Dictionary.join(t3.children or t1, {
			focusNavActions = t3.focusNavActionsComponent
		})),
		HoldDetector = if not v64 or not v64.holdDetectorProps then nil else React.createElement(HoldDetector, v64.holdDetectorProps)
	})
end

return React.memo(SduiTile)
