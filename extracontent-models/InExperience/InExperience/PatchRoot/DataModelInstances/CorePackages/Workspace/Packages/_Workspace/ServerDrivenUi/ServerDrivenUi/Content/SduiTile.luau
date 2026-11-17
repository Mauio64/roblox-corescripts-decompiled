local ContentProvider = game:GetService("ContentProvider")
local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local GetInputModeStore = Responsive.GetInputModeStore
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local UIBlox = require(parent.UIBlox)
local Cryo = require(parent.Cryo)
local LoadableImage = UIBlox.App.Loading.LoadableImage
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local TextSize = require(parent.TextSize)
require(parent.SduiCoreSystem)

local HoldToPlay = require(parent.HoldToPlay)
local HoldDetector = HoldToPlay.HoldDetector
local SduiDefaultTileImage = require(script.Parent.SduiDefaultTileImage)
local useTileHoldAction = require(script.Parent.useTileHoldAction)

local Flags = require(ServerDrivenUi.Flags)
local FFlagSduiTileDisableLegacyHover = Flags.FFlagSduiTileDisableLegacyHover
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiGameTileEnableHoverInVR = SharedFlags.FFlagSduiGameTileEnableHoverInVR

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppHomePageFirstImageLoadObserver = SharedFlags2.FFlagLuaAppHomePageFirstImageLoadObserver
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSduiTileThumbnailPadding = SharedFlags3.FFlagSduiTileThumbnailPadding
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppSduiVideoThumbnail = SharedFlags4.FFlagLuaAppSduiVideoThumbnail
local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppSduiGameTileFeedback = SharedFlags5.FFlagLuaAppSduiGameTileFeedback

local SduiTileInsetImage = require(script.Parent.SduiTileInsetImage)

local v = {}

local function isRobloxContentUrl(value: string): boolean
	return string.match(value, "^rbxthumb://") ~= nil or string.match(value, "^rbxasset") ~= nil
end

local function maybeLayoutForButton(p, ctaButtonComponent, small: number, p2: number, flag: boolean?)
	if ctaButtonComponent == nil or flag then
		return p
	end

	local createElement = React.createElement
	local v2 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v3 = {
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalFlex = Enum.UIFlexAlignment.None,
			SortOrder = Enum.SortOrder.Name,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, small or 0),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}),
		UIPadding = 0,
		LeftContent = 0,
		RightContent = 0
	}
	local uiPadding

	if p2 > 0 then
		uiPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, p2),
			PaddingRight = UDim.new(0, p2),
			PaddingBottom = UDim.new(0, p2)
		})
	end

	v3.UIPadding = uiPadding

	v3.LeftContent = React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		},
		Cryo.Dictionary.join({
			UIFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Shrink })
		}, p)
	)

	v3.RightContent = ctaButtonComponent
	return { Content = createElement("Frame", v2, v3) }
end

local function SduiTile(props)
	local layoutOrder = props.layoutOrder
	local anchorPoint = props.anchorPoint
	local automaticSize = props.automaticSize
	local size = props.size
	local zIndex = props.zIndex
	local position = props.position
	local backgroundColor3 = props.backgroundColor3
	local selectionOrder = props.selectionOrder

	React.useLayoutEffect(function()
		local image = props.image

		if image and (string.match(image, "^rbxthumb://") ~= nil or string.match(image, "^rbxasset") ~= nil) then
			task.spawn(function()
				ContentProvider:PreloadAsync({ image })
			end)
		end
	end, { props.image })

	local textSizeOffset = TextSize.getTextSizeStore(false).getTextSizeOffset(false)

	local v2 = useTokens()

	local v3 = props.imageAspectRatio and props.imageAspectRatio == 0 and 1 or props.imageAspectRatio or 1

	local titleLines = props.titleLines or 1
	local cornerRadius = props.cornerRadius or v2.Radius.Medium

	local titleFont = props.titleFont or v2.Typography.TitleMedium
	local emphasis = v2.Color.Content.Emphasis
	local v4 = math.ceil(titleLines * (titleFont.LineHeight * titleFont.FontSize + textSizeOffset))

	local v5 = props.ctaButtonComponent ~= nil

	local state, setState = React.useState(false)

	local isContained = props.isContained
	local v6, backgroundColor

	if props.backgroundStyle == nil then
		v6 = v2.Color.Surface.Surface_100
		backgroundColor = backgroundColor3 or v6.Color3
	else
		v6 = props.backgroundStyle

		backgroundColor = v6.Color3
	end

	local containmentPadding = props.containmentPadding or v2.Padding.Small

	local state2, setState2 = React.useState(false)

	if props.isHovered ~= nil then
		state2 = props.isHovered
	end

	local v7 = React.useCallback(function()
		local v7

		if FFlagSduiGameTileEnableHoverInVR then
			v7 = GetInputModeStore(false).getPreferredInputType(false)
		else
			v7 = GetInputModeStore(false).getLastInputType(false)
		end

		if v7 == Responsive.Input.Pointer then
			setState2(true)

			if props.onMouseEnter then
				props.onMouseEnter()
			elseif props.setCustomConditionState then
				props.setCustomConditionState("hovered", true)
			end
		end
	end, { props.onMouseEnter, props.setCustomConditionState })

	local v8 = React.useCallback(function()
		setState2(false)

		if props.onMouseLeave then
			props.onMouseLeave()
		elseif props.setCustomConditionState then
			props.setCustomConditionState("hovered", false)
		end
	end, { props.onMouseLeave, props.setCustomConditionState })

	local v9 = React.useCallback(function()
		if props.onSelectionGained then
			props.onSelectionGained()
		elseif props.setCustomConditionState then
			props.setCustomConditionState("selected", true)
		end
	end, { props.onSelectionGained, props.setCustomConditionState })

	local v10 = React.useCallback(function()
		if props.onSelectionLost then
			props.onSelectionLost()
		elseif props.setCustomConditionState then
			props.setCustomConditionState("selected", false)
		end
	end, { props.onSelectionLost, props.setCustomConditionState })

	local v11 = useTileHoldAction(props.holdActionConfig, props.setGuiObject, props.onActivated)
	local v12, v13, v14

	if FFlagLuaAppSduiGameTileFeedback then
		local ref = React.useRef(false)

		v12 = React.useCallback(function(...)
			ref.current = false

			if props.onGuiStateChanged then
				props.onGuiStateChanged(...)
			end
		end, { props.onGuiStateChanged })

		v13 = React.useCallback(function()
			if ref.current then
				ref.current = false
			elseif v11 then
				v11.onActivated()
			elseif props.onActivated then
				props.onActivated()
			end
		end, { v11, props.onActivated })

		v14 = React.useCallback(function()
			if props.onTouchLongPress and not props.isDisabled then
				local current = ref.current
				ref.current = true

				if not current then
					props.onTouchLongPress()
				end
			end
		end, { props.onTouchLongPress, props.isDisabled })
	end

	local udim, udim2, v15, containmentPadding2

	if not (FFlagSduiTileDisableLegacyHover or not props.enableLegacyHoverState) then
		containmentPadding2 = props.containmentPadding or v2.Padding.Medium

		if state2 then
			udim = UDim2.new(1, containmentPadding2 * 2, 1, containmentPadding2 * 2)
		end

		if state2 then
			udim2 = UDim2.new(0, -containmentPadding2, 0, -containmentPadding2)
			v15 = state2
		else
			v15 = state2
		end
	end

	local transparency = v6.Transparency
	local thumbnail

	if props.imagePadding ~= nil then
		thumbnail = React.createElement(SduiTileInsetImage, {
			image = props.image,
			imageComponent = props.imageComponent,
			imagePadding = props.imagePadding,
			imageCornerRadius = props.imageCornerRadius or 1000,
			cardCornerRadius = cornerRadius,
			isContained = isContained,
			backgroundStyle = props.thumbnailBackgroundStyle
		})
	end

	local createElement = React.createElement
	local tag = React.Tag
	local v16

	if props.testId then
		v16 = `data-testid={props.testId}`
	end

	local v17 = { [tag] = v16 }

	local ref = if v11 then v11.tileRef else props.setGuiObject
	v17.ref = ref
	v17.Size = udim or size or UDim2.new(1, 0, 1, 0)
	v17.Position = udim2 or position
	v17.AnchorPoint = anchorPoint
	v17.LayoutOrder = layoutOrder
	v17.ZIndex = zIndex
	v17.SelectionImageObject = props.sduiContext.dependencies.cursors.tileCursor
	local active

	if FFlagLuaAppSduiGameTileFeedback then
		active = not props.isDisabled
	else
		active = props.isDisabled
	end

	v17.Active = active
	local selectable

	if FFlagLuaAppSduiGameTileFeedback then
		selectable = props.selectable
	end

	v17.Selectable = selectable
	local guiState = React.Change.GuiState

	if not FFlagLuaAppSduiGameTileFeedback then
		v12 = props.onGuiStateChanged
	end

	v17[guiState] = v12

	local activated = React.Event.Activated

	if not FFlagLuaAppSduiGameTileFeedback then
		v13 = if v11 then v11.onActivated else props.onActivated
	end

	v17[activated] = v13

	v17[React.Event.MouseEnter] = v7
	v17[React.Event.MouseLeave] = v8
	v17[React.Event.SelectionGained] = v9
	v17[React.Event.SelectionLost] = v10
	local touchLongPress = React.Event.TouchLongPress

	if not (FFlagLuaAppSduiGameTileFeedback and props.onTouchLongPress) then
		v14 = nil
	end

	v17[touchLongPress] = v14

	v17.ClipsDescendants = false
	v17.Text = ""
	v17.TextTransparency = 1
	v17.BackgroundTransparency = not (isContained or v15) and 1 or transparency
	v17.AutoButtonColor = false
	v17.AutomaticSize = automaticSize or Enum.AutomaticSize.Y
	v17.BackgroundColor3 = backgroundColor
	v17.BorderSizePixel = 0
	v17.SelectionOrder = selectionOrder
	local uiPadding

	if not (FFlagSduiTileDisableLegacyHover or not v15) then
		uiPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, containmentPadding2),
			PaddingRight = UDim.new(0, containmentPadding2),
			PaddingTop = UDim.new(0, containmentPadding2)
		})
	end

	local uiCorner

	if isContained or not FFlagSduiTileDisableLegacyHover and v15 then
		uiCorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, cornerRadius) })
	end

	local createElement2 = React.createElement
	local v18 = {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, v2.Gap.Medium),
		HorizontalAlignment = 0
	}
	local horizontalAlignment

	if FFlagSduiTileThumbnailPadding then
		horizontalAlignment = Enum.HorizontalAlignment.Center
	end

	v18.HorizontalAlignment = horizontalAlignment
	local children = {
		UIPadding = uiPadding,
		UICorner = uiCorner,
		UIListLayout = createElement2("UIListLayout", v18),
		ImageFrame = 0,
		BottomContent = 0,
		ExtraChildren = 0,
		HoldDetector = 0
	}

	local createElement3 = React.createElement
	local v19 = {
		[React.Tag] = FFlagLuaAppHomePageFirstImageLoadObserver and "observed-image" or nil,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}
	local size2

	if FFlagSduiTileThumbnailPadding and props.thumbnailPadding ~= nil then
		size2 = UDim2.new(1, props.thumbnailPadding * -2, 1 / v3, 0)
	else
		size2 = UDim2.new(1, 0, 1 / v3, 0)
	end

	v19.Size = size2

	v19.ZIndex = -1
	v19.LayoutOrder = 1
	v19.ClipsDescendants = isContained and true or nil
	v19.SizeConstraint = Enum.SizeConstraint.RelativeXX
	local backgroundImage

	if props.backgroundImageComponent then
		backgroundImage = props.backgroundImageComponent
	elseif props.backgroundImage then
		backgroundImage = React.createElement(
			ImageSetLabel,
			{
				Size = UDim2.new(1, 0, 1, 0),
				Image = props.backgroundImage,
				BackgroundTransparency = 1,
				ZIndex = -3
			},
			{
				UICorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, cornerRadius)
				})
			}
		)
	end

	if not thumbnail then
		if props.imageComponent then
			thumbnail = props.imageComponent
		elseif props.image then
			if FFlagLuaAppSduiVideoThumbnail then
				thumbnail = React.createElement(SduiDefaultTileImage, {
					image = props.image,
					thumbnailBackgroundStyle = props.thumbnailBackgroundStyle,
					isContained = isContained,
					cardCornerRadius = cornerRadius
				})
			else
				local createElement4 = React.createElement
				local backgroundColor2

				if props.thumbnailBackgroundStyle then
					backgroundColor2 = props.thumbnailBackgroundStyle.Color3 or nil
				end

				local v20 = {
					BackgroundColor3 = backgroundColor2,
					BackgroundTransparency = props.thumbnailBackgroundStyle and props.thumbnailBackgroundStyle.Transparency or 1,
					Image = props.image,
					Size = UDim2.new(1, 0, 1, not isContained and 0 or cornerRadius),
					cornerRadius = UDim.new(0, cornerRadius),
					showFailedStateWhenLoadingFailed = true,
					useShimmerAnimationWhileLoading = true,
					ZIndex = -2,
					ScaleType = 0,
					TileSize = 0
				}
				local scaleType

				if isContained then
					scaleType = Enum.ScaleType.Tile
				end

				v20.ScaleType = scaleType
				local tileSize

				if isContained then
					tileSize = UDim2.new(1, 0, 1, -cornerRadius)
				end

				v20.TileSize = tileSize
				thumbnail = createElement4(LoadableImage, v20)
			end
		else
			thumbnail = nil
		end
	end

	local v20 = {
		BackgroundImage = backgroundImage,
		Thumbnail = thumbnail,
		UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = v3 or 1
		}),
		ThumbnailOverlay = props.thumbnailOverlayComponent,
		OverflowMenu = 0,
		HoverOverlay = 0
	}
	local overflowMenu

	if FFlagLuaAppSduiGameTileFeedback then
		overflowMenu = props.thumbnailOverflowMenuComponent
	end

	v20.OverflowMenu = overflowMenu
	local hoverOverlay

	if state2 and not state then
		hoverOverlay = React.createElement("Frame", {
			BackgroundColor3 = v2.Color.State.Hover.Color3,
			BackgroundTransparency = v2.Color.State.Hover.Transparency,
			Size = UDim2.new(1, 0, 1, not isContained and 0 or cornerRadius)
		}, {
			UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, cornerRadius) })
		})
	end

	v20.HoverOverlay = hoverOverlay
	children.ImageFrame = createElement3("Frame", v19, v20)

	local createElement4 = React.createElement

	local v21 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = 2,
		ZIndex = 1
	}
	local uiPadding2

	if isContained and not v5 then
		uiPadding2 = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, containmentPadding),
			PaddingRight = UDim.new(0, containmentPadding),
			PaddingBottom = UDim.new(0, containmentPadding)
		})
	end

	local v22 = {
		["UIPadding"] = nil,
		["UIPadding"] = nil,
		["UIPadding"] = nil,
		UIPadding = uiPadding2,
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.Name,
			HorizontalFlex = Enum.UIFlexAlignment.Fill
		})
	}
	local _1_Title

	if props.titleComponent then
		_1_Title = props.titleComponent
	elseif props.titleText and props.titleText ~= "" then
		_1_Title = React.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, v4),
			BackgroundTransparency = 1,
			Text = props.titleText,
			FontFace = normalizeFontFace(titleFont.Font),
			TextSize = titleFont.FontSize,
			TextTransparency = emphasis.Transparency,
			TextColor3 = emphasis.Color3,
			TextWrapped = titleLines > 1,
			TextTruncate = Enum.TextTruncate.SplitWord,
			TextXAlignment = props.titleTextXAlignment or Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			AutomaticSize = v5 and Enum.AutomaticSize.X or nil
		})
	end

	v22["1_Title"] = _1_Title
	local _2_Footer

	if props.footerComponent then
		_2_Footer = props.footerComponent
	end

	v22["2_Footer"] = _2_Footer
	local _3_BottomButton

	if props.bottomButtonComponent then
		_3_BottomButton = React.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			[React.Event.MouseEnter] = function()
				if setState then
					setState(true)
				end
			end,
			[React.Event.MouseLeave] = function()
				if setState then
					setState(false)
				end
			end
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, props.bottomButtonGap or v2.Gap.Small)
			}),
			Content = props.bottomButtonComponent
		})
	end

	v22["3_BottomButton"] = _3_BottomButton
	local Z_3_ExtraOverflow

	if not (FFlagSduiTileDisableLegacyHover or not (v15 and props.renderLegacyHoverState)) then
		Z_3_ExtraOverflow = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			ZIndex = -1
		}, {
			ExtraOverflow = props.renderLegacyHoverState(containmentPadding2, backgroundColor, cornerRadius)
		})
	end

	v22.Z_3_ExtraOverflow = Z_3_ExtraOverflow
	children.BottomContent = createElement4(
		"Frame",
		v21,
		maybeLayoutForButton(
			v22,
			props.ctaButtonComponent,
			v2.Gap.Small,
			not isContained and 0 or containmentPadding,
			v15
		)
	)
	local extraChildren

	if props.focusNavActionsComponent or props.children then
		extraChildren = React.createElement(
			React.Fragment,
			nil,
			Cryo.Dictionary.join(props.children or v, {
				focusNavActions = props.focusNavActionsComponent
			})
		)
	end

	children.ExtraChildren = extraChildren
	local holdDetector

	if v11 and v11.holdDetectorProps then
		holdDetector = React.createElement(HoldDetector, v11.holdDetectorProps)
	end

	children.HoldDetector = holdDetector
	return createElement("TextButton", v17, children)
end

return React.memo(SduiTile)
