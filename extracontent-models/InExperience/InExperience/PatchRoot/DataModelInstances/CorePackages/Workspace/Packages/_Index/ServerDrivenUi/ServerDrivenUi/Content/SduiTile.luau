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
local FFlagSduiGameIconSupport = require(ServerDrivenUiParent.SharedFlags).FFlagSduiGameIconSupport
local FFlagSduiTileThumbnailPadding = require(ServerDrivenUiParent.SharedFlags).FFlagSduiTileThumbnailPadding
local SduiTileInsetImage = require(script.Parent.SduiTileInsetImage)
local t1 = {}

local function isRobloxContentUrl(s1: string) -- line: 48
	return string.match(s1, "^rbxthumb://") ~= nil or string.match(s1, "^rbxasset") ~= nil
end
local function maybeLayoutForButton(t2: {[any]: any}, p1, n1: number, n2: number, b1: boolean?) -- line: 150
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
local function SduiTile(t3: {[any]: any}) -- line: 203
	-- upvalues: React (copy), FFlagSduiGameIconSupport (copy), ContentProvider (copy), TextSize (copy), useTokens (copy), FFlagSduiTileBottomButton (copy), FFlagSduiExperienceDetailsSupport (copy), GetInputModeStore (copy), Responsive (copy), FFlagSduiTileHoldAction (copy), useTileHoldAction (copy), FFlagSduiTileDisableLegacyHover (copy), FFlagSduiTileImagePaddingInset (copy), SduiTileInsetImage (copy), FFlagSduiTileThumbnailPadding (copy), FFlagLuaAppHomePageFirstImageLoadObserver (copy), ImageSetLabel (copy), LoadableImage (copy), FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone (copy), maybeLayoutForButton (copy), FFlagSduiTileTitleTextAlignment (copy), Cryo (copy), t1 (copy), HoldDetector (copy)
	local layoutOrder = t3.layoutOrder
	local anchorPoint = t3.anchorPoint
	local automaticSize = t3.automaticSize
	local size = t3.size
	local zIndex = t3.zIndex
	local position = t3.position
	local backgroundColor3 = t3.backgroundColor3
	local selectionOrder = t3.selectionOrder

	React.useLayoutEffect(function() -- line: 213
		-- upvalues: t3 (copy), FFlagSduiGameIconSupport (copy), ContentProvider (copy)
		local image = t3.image

		if image and (not FFlagSduiGameIconSupport or (string.match(image, "^rbxthumb://") ~= nil or string.match(image, "^rbxasset") ~= nil)) then
			task.spawn(function() -- line: 216
				-- upvalues: ContentProvider (copy), image (copy)
				ContentProvider:PreloadAsync({ image })
			end)
		end
	end, { t3.image })

	local v45 = TextSize.getTextSizeStore(false).getTextSizeOffset(false)
	local v46 = useTokens()
	local v47 = if not t3.imageAspectRatio or t3.imageAspectRatio ~= 0 then t3.imageAspectRatio or 1 else 1
	local v48 = t3.titleLines or 1
	local v49 = t3.cornerRadius or v46.Radius.Medium
	local v50 = t3.titleFont or v46.Typography.TitleMedium
	local Emphasis = v46.Color.Content.Emphasis
	local v52 = math.ceil(v48 * (v50.LineHeight * v50.FontSize + v45))
	local v53 = t3.ctaButtonComponent ~= nil
	local v54 = nil
	local u55 = nil

	if FFlagSduiTileBottomButton then
		local v56

		v54, v56 = React.useState(false)
		u55 = v56
	end

	local isContained = t3.isContained
	local backgroundStyle, backgroundStyleColor3

	if FFlagSduiExperienceDetailsSupport and t3.backgroundStyle ~= nil then
		backgroundStyle = t3.backgroundStyle
		backgroundStyleColor3 = backgroundStyle.Color3
	else
		backgroundStyle = v46.Color.Surface.Surface_100
		backgroundStyleColor3 = backgroundColor3 or backgroundStyle.Color3
	end

	local v60 = t3.containmentPadding or v46.Padding.Small
	local v61, v62 = React.useState(false)
	local v63 = if t3.isHovered == nil then v61 else t3.isHovered
	local v64 = React.useCallback(function() -- line: 263
		-- upvalues: GetInputModeStore (copy), Responsive (copy), v62 (copy), t3 (copy)
		if GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Pointer then
			v62(true)

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
	local v65 = React.useCallback(function() -- line: 276
		-- upvalues: v62 (copy), t3 (copy)
		v62(false)

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
	local v66 = React.useCallback(function() -- line: 285
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
	local v67 = React.useCallback(function() -- line: 293
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
	local v68 = nil

	if FFlagSduiTileHoldAction then
		v68 = useTileHoldAction(t3.holdActionConfig, t3.setGuiObject, t3.onActivated)
	end

	local v69 = nil
	local v70 = nil
	local v71 = nil
	local v72 = nil

	if not FFlagSduiTileDisableLegacyHover and t3.enableLegacyHoverState then
		v69 = v63
		v70 = t3.containmentPadding or v46.Padding.Medium
		v71 = if not v63 then nil else UDim2.new(1, v70 * 2, 1, v70 * 2)
		v72 = if not v63 then nil else UDim2.new(0, -v70, 0, -v70)
	end

	local v73 = not FFlagSduiExperienceDetailsSupport and 0 or backgroundStyle.Transparency
	local v74 = nil

	if FFlagSduiTileImagePaddingInset and t3.imagePadding ~= nil then
		v74 = React.createElement(SduiTileInsetImage, {
			image = t3.image,
			imageComponent = t3.imageComponent,
			imagePadding = t3.imagePadding,
			imageCornerRadius = t3.imageCornerRadius or 1000,
			cardCornerRadius = v49,
			isContained = isContained,
			backgroundStyle = t3.thumbnailBackgroundStyle
		})
	end

	return React.createElement("TextButton", {
		[React.Tag] = if not t3.testId then nil else `data-testid={ t3.testId }`,
		ref = if not v68 then t3.setGuiObject else v68.tileRef,
		Size = v71 or (size or UDim2.new(1, 0, 1, 0)),
		Position = v72 or position,
		AnchorPoint = anchorPoint,
		LayoutOrder = layoutOrder,
		ZIndex = zIndex,
		SelectionImageObject = t3.sduiContext.dependencies.cursors.tileCursor,
		Active = t3.isDisabled,
		[React.Event.Activated] = if not v68 then t3.onActivated else v68.onActivated,
		[React.Event.MouseEnter] = v64,
		[React.Event.MouseLeave] = v65,
		[React.Event.SelectionGained] = v66,
		[React.Event.SelectionLost] = v67,
		ClipsDescendants = false,
		Text = "",
		TextTransparency = 1,
		BackgroundTransparency = not isContained and not v69 and 1 or v73,
		AutoButtonColor = false,
		AutomaticSize = automaticSize or Enum.AutomaticSize.Y,
		BackgroundColor3 = backgroundStyleColor3,
		BorderSizePixel = 0,
		SelectionOrder = selectionOrder
	}, {
		UIPadding = if not FFlagSduiTileDisableLegacyHover then if not v69 then nil else React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v70),
			PaddingRight = UDim.new(0, v70),
			PaddingTop = UDim.new(0, v70)
		}) else nil,
		UICorner = if not isContained and (FFlagSduiTileDisableLegacyHover or not v69) then nil else React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v49)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v46.Gap.Medium),
			HorizontalAlignment = if not FFlagSduiTileThumbnailPadding then nil else Enum.HorizontalAlignment.Center
		}),
		ImageFrame = React.createElement("Frame", {
			[React.Tag] = if not FFlagLuaAppHomePageFirstImageLoadObserver then nil else "observed-image",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = if not FFlagSduiTileThumbnailPadding or t3.thumbnailPadding == nil then UDim2.new(1, 0, 1 / v47, 0) else UDim2.new(1, t3.thumbnailPadding * -2, 1 / v47, 0),
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
					CornerRadius = UDim.new(0, v49)
				})
			}) else t3.backgroundImageComponent,
			Thumbnail = if not v74 then if not t3.imageComponent then if not t3.image then nil else React.createElement(LoadableImage, {
				showFailedStateWhenLoadingFailed = true,
				useShimmerAnimationWhileLoading = true,
				ZIndex = -2,
				BackgroundColor3 = t3.thumbnailBackgroundStyle and t3.thumbnailBackgroundStyle.Color3 or nil,
				BackgroundTransparency = t3.thumbnailBackgroundStyle and t3.thumbnailBackgroundStyle.Transparency or 1,
				Image = t3.image,
				Size = UDim2.new(1, 0, 1, not isContained and 0 or v49),
				cornerRadius = UDim.new(0, v49),
				ScaleType = if not isContained then nil else Enum.ScaleType.Tile,
				TileSize = if not isContained then nil else UDim2.new(1, 0, 1, -v49),
				onLoaded = if not FFlagLuaAppHomeFirstTileThumbnailLoadedMilestone then nil else t3.onTileImageLoaded
			}) else t3.imageComponent else v74,
			UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = v47 or 1
			}),
			ThumbnailOverlay = t3.thumbnailOverlayComponent,
			HoverOverlay = if not v63 or not not FFlagSduiTileBottomButton and v54 then nil else React.createElement("Frame", {
				BackgroundColor3 = v46.Color.State.Hover.Color3,
				BackgroundTransparency = v46.Color.State.Hover.Transparency,
				Size = UDim2.new(1, 0, 1, not isContained and 0 or v49)
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v49)
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
			UIPadding = if not isContained or v53 then nil else React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v60),
				PaddingRight = UDim.new(0, v60),
				PaddingBottom = UDim.new(0, v60)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.Name,
				HorizontalFlex = Enum.UIFlexAlignment.Fill
			}),
			["1_Title"] = if not t3.titleComponent then if not t3.titleText or t3.titleText == "" then nil else React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v52),
				Text = t3.titleText,
				Font = v50.Font,
				TextSize = v50.FontSize,
				TextTransparency = Emphasis.Transparency,
				TextColor3 = Emphasis.Color3,
				TextWrapped = v48 > 1,
				TextTruncate = Enum.TextTruncate.SplitWord,
				TextXAlignment = if not FFlagSduiTileTitleTextAlignment then Enum.TextXAlignment.Left else t3.titleTextXAlignment or Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				AutomaticSize = v53 and Enum.AutomaticSize.X or nil
			}) else t3.titleComponent,
			["2_Footer"] = if not t3.footerComponent then nil else t3.footerComponent,
			["3_BottomButton"] = if not FFlagSduiTileBottomButton or not t3.bottomButtonComponent then nil else React.createElement("Frame", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				[React.Event.MouseEnter] = function() -- line: 502
					-- upvalues: u55 (ref)
					if u55 then
						u55(true)
					end
				end,
				[React.Event.MouseLeave] = function() -- line: 507
					-- upvalues: u55 (ref)
					if u55 then
						u55(false)
					end
				end
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, t3.bottomButtonGap or v46.Gap.Small)
				}),
				Content = t3.bottomButtonComponent
			}),
			Z_3_ExtraOverflow = if not FFlagSduiTileDisableLegacyHover then if not v69 or not t3.renderLegacyHoverState then nil else React.createElement("Frame", {
				ZIndex = -1,
				Size = UDim2.new(1, 0, 0, 0)
			}, {
				ExtraOverflow = t3.renderLegacyHoverState(v70, backgroundStyleColor3, v49)
			}) else nil
		}, t3.ctaButtonComponent, v46.Gap.Small, not isContained and 0 or v60, v69))),
		ExtraChildren = if not t3.focusNavActionsComponent and not t3.children then nil else React.createElement(React.Fragment, nil, Cryo.Dictionary.join(t3.children or t1, {
			focusNavActions = t3.focusNavActionsComponent
		})),
		HoldDetector = if not v68 or not v68.holdDetectorProps then nil else React.createElement(HoldDetector, v68.holdDetectorProps)
	})
end

return React.memo(SduiTile)
