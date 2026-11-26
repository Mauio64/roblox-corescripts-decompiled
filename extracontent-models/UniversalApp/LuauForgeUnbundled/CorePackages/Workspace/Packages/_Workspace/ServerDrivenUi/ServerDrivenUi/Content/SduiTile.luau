local ContentProvider = game:GetService("ContentProvider")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Responsive")
local getInputModeStore = Responsive.GetInputModeStore
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/UIBlox")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Cryo")
local loadableImage = UIBlox.App.Loading.LoadableImage
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/TextSize")
require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")

local holdDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/HoldToPlay").HoldDetector
local SduiDefaultTileImage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiDefaultTileImage")
local useTileHoldAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/useTileHoldAction")

local fFlagSduiTileDisableLegacyHover = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Flags").FFlagSduiTileDisableLegacyHover
local fFlagSduiGameTileEnableHoverInVR = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiGameTileEnableHoverInVR

local fFlagLuaAppHomePageFirstImageLoadObserver = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppHomePageFirstImageLoadObserver
local fFlagSduiTileThumbnailPadding = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiTileThumbnailPadding
local fFlagLuaAppSduiVideoThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiVideoThumbnail
local fFlagLuaAppSduiGameTileFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiGameTileFeedback

local SduiTileInsetImage = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/SduiTileInsetImage")

local v5 = {}

local function isRobloxContentUrl(value): boolean
	return string.match(value, "^rbxthumb://") ~= nil or string.match(value, "^rbxasset") ~= nil
end

local function maybeLayoutForButton(p2, rightContent, value, p3, p4)
	if rightContent == nil or p4 then
		return p2
	end

	local createElement = React.createElement
	local v8 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v9 = {
		UIListLayout = React.createElement("UIListLayout", {
			HorizontalFlex = Enum.UIFlexAlignment.None,
			SortOrder = Enum.SortOrder.Name,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, value or 0),
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}),
		UIPadding = 0,
		LeftContent = 0,
		RightContent = 0
	}

	local v10 = if p3 > 0 then React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, p3),
		PaddingRight = UDim.new(0, p3),
		PaddingBottom = UDim.new(0, p3)
	}) else nil
	v9.UIPadding = v10

	v9.LeftContent = React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		},
		Cryo.Dictionary.join({
			UIFlexItem = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Shrink
			})
		}, p2)
	)

	v9.RightContent = rightContent
	return { Content = createElement("Frame", v8, v9) }
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

		if
			image
			and (string.match(image, "^rbxthumb://") ~= nil or string.match(image, "^rbxasset") ~= nil)
		then
			task.spawn(function()
				ContentProvider:PreloadAsync({ image })
			end)
		end
	end, { props.image })

	local textSizeOffset = module6.getTextSizeStore(false).getTextSizeOffset(false)

	local v6 = useTokens()

	local v7 = props.imageAspectRatio and props.imageAspectRatio == 0 and 1 or props.imageAspectRatio or 1

	local titleLines = props.titleLines or 1
	local cornerRadius = props.cornerRadius or v6.Radius.Medium

	local titleFont = props.titleFont or v6.Typography.TitleMedium
	local emphasis = v6.Color.Content.Emphasis
	local v8 = math.ceil(titleLines * (titleFont.LineHeight * titleFont.FontSize + textSizeOffset))

	local v9 = props.ctaButtonComponent ~= nil

	local state, setState = React.useState(false)

	local isContained = props.isContained
	local v10, v11

	if props.backgroundStyle == nil then
		v10 = v6.Color.Surface.Surface_100
		v11 = backgroundColor3 or v10.Color3
	else
		v10 = props.backgroundStyle

		v11 = v10.Color3
	end

	local containmentPadding = props.containmentPadding or v6.Padding.Small

	local state2, setState2 = React.useState(false)

	if props.isHovered ~= nil then
		state2 = props.isHovered
	end

	local v12 = React.useCallback(function()
		local v13

		if fFlagSduiGameTileEnableHoverInVR then
			v13 = getInputModeStore(false).getPreferredInputType(false)
		else
			v13 = getInputModeStore(false).getLastInputType(false)
		end

		if v13 == Responsive.Input.Pointer then
			setState2(true)

			if props.onMouseEnter then
				props.onMouseEnter()
			elseif props.setCustomConditionState then
				props.setCustomConditionState("hovered", true)
			end
		end
	end, { props.onMouseEnter, props.setCustomConditionState })

	local v13 = React.useCallback(function()
		setState2(false)

		if props.onMouseLeave then
			props.onMouseLeave()
		elseif props.setCustomConditionState then
			props.setCustomConditionState("hovered", false)
		end
	end, { props.onMouseLeave, props.setCustomConditionState })

	local v14 = React.useCallback(function()
		if props.onSelectionGained then
			props.onSelectionGained()
		elseif props.setCustomConditionState then
			props.setCustomConditionState("selected", true)
		end
	end, { props.onSelectionGained, props.setCustomConditionState })

	local v15 = React.useCallback(function()
		if props.onSelectionLost then
			props.onSelectionLost()
		elseif props.setCustomConditionState then
			props.setCustomConditionState("selected", false)
		end
	end, { props.onSelectionLost, props.setCustomConditionState })

	local v16 = useTileHoldAction(props.holdActionConfig, props.setGuiObject, props.onActivated)
	local v17, v18, v19

	if fFlagLuaAppSduiGameTileFeedback then
		local ref = React.useRef(false)

		v17 = React.useCallback(function(...)
			ref.current = false

			if props.onGuiStateChanged then
				props.onGuiStateChanged(...)
			end
		end, { props.onGuiStateChanged })

		v18 = React.useCallback(function()
			if ref.current then
				ref.current = false
			elseif v16 then
				v16.onActivated()
			elseif props.onActivated then
				props.onActivated()
			end
		end, { v16, props.onActivated })

		v19 = React.useCallback(function()
			if props.onTouchLongPress and not props.isDisabled then
				local current = ref.current
				ref.current = true

				if not current then
					props.onTouchLongPress()
				end
			end
		end, { props.onTouchLongPress, props.isDisabled })
	end

	local udim, udim2, v20, containmentPadding2

	if not (fFlagSduiTileDisableLegacyHover or not props.enableLegacyHoverState) then
		containmentPadding2 = props.containmentPadding or v6.Padding.Medium

		if state2 then
			udim = UDim2.new(1, containmentPadding2 * 2, 1, containmentPadding2 * 2)
		end

		if state2 then
			udim2 = UDim2.new(0, -containmentPadding2, 0, -containmentPadding2)
			v20 = state2
		else
			v20 = state2
		end
	end

	local transparency = v10.Transparency
	local v21

	if props.imagePadding ~= nil then
		v21 = React.createElement(SduiTileInsetImage, {
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
	local v24 = if props.testId then `data-testid={props.testId}` else nil
	local v23 = { [tag] = v24 }

	local v25 = if v16 then v16.tileRef else props.setGuiObject
	v23.ref = v25
	v23.Size = udim or size or UDim2.new(1, 0, 1, 0)
	v23.Position = udim2 or position
	v23.AnchorPoint = anchorPoint
	v23.LayoutOrder = layoutOrder
	v23.ZIndex = zIndex
	v23.SelectionImageObject = props.sduiContext.dependencies.cursors.tileCursor
	local v26 = if fFlagLuaAppSduiGameTileFeedback then not props.isDisabled else props.isDisabled
	v23.Active = v26
	local v27 = if fFlagLuaAppSduiGameTileFeedback then props.selectable else nil
	v23.Selectable = v27
	local guiState = React.Change.GuiState

	if not fFlagLuaAppSduiGameTileFeedback then
		v17 = props.onGuiStateChanged
	end

	v23[guiState] = v17

	local activated = React.Event.Activated

	if not fFlagLuaAppSduiGameTileFeedback then
		v18 = if v16 then v16.onActivated else props.onActivated
	end

	v23[activated] = v18

	v23[React.Event.MouseEnter] = v12
	v23[React.Event.MouseLeave] = v13
	v23[React.Event.SelectionGained] = v14
	v23[React.Event.SelectionLost] = v15
	local touchLongPress = React.Event.TouchLongPress

	if not (fFlagLuaAppSduiGameTileFeedback and props.onTouchLongPress) then
		v19 = nil
	end

	v23[touchLongPress] = v19

	v23.ClipsDescendants = false
	v23.Text = ""
	v23.TextTransparency = 1
	v23.BackgroundTransparency = not (isContained or v20) and 1 or transparency
	v23.AutoButtonColor = false
	v23.AutomaticSize = automaticSize or Enum.AutomaticSize.Y
	v23.BackgroundColor3 = v11
	v23.BorderSizePixel = 0
	v23.SelectionOrder = selectionOrder

	local v28 = if not (fFlagSduiTileDisableLegacyHover or not v20) then React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, containmentPadding2),
		PaddingRight = UDim.new(0, containmentPadding2),
		PaddingTop = UDim.new(0, containmentPadding2)
	}) else nil

	local v29 = if isContained or not fFlagSduiTileDisableLegacyHover and v20 then React.createElement("UICorner", {
		CornerRadius = UDim.new(0, cornerRadius)
	}) else nil

	local createElement2 = React.createElement
	local v31 = {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, v6.Gap.Medium),
		HorizontalAlignment = 0
	}
	local v32 = if fFlagSduiTileThumbnailPadding then Enum.HorizontalAlignment.Center else nil
	v31.HorizontalAlignment = v32
	local children = {
		UIPadding = v28,
		UICorner = v29,
		UIListLayout = createElement2("UIListLayout", v31),
		ImageFrame = 0,
		BottomContent = 0,
		ExtraChildren = 0,
		HoldDetector = 0
	}

	local createElement3 = React.createElement
	local v34 = {
		[React.Tag] = fFlagLuaAppHomePageFirstImageLoadObserver and "observed-image" or nil,
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local v35 = if fFlagSduiTileThumbnailPadding and props.thumbnailPadding ~= nil then UDim2.new(1, -2 * props.thumbnailPadding, 1 / v7, 0) else UDim2.new(1, 0, 1 / v7, 0)
	v34.Size = v35

	v34.ZIndex = -1
	v34.LayoutOrder = 1
	v34.ClipsDescendants = isContained and true or nil
	v34.SizeConstraint = Enum.SizeConstraint.RelativeXX
	local v37

	if props.backgroundImageComponent then
		v37 = props.backgroundImageComponent
	elseif props.backgroundImage then
		v37 = React.createElement(
			imageSetLabel,
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

	if not v21 then
		if props.imageComponent then
			v21 = props.imageComponent
		elseif props.image then
			if fFlagLuaAppSduiVideoThumbnail then
				v21 = React.createElement(SduiDefaultTileImage, {
					image = props.image,
					thumbnailBackgroundStyle = props.thumbnailBackgroundStyle,
					isContained = isContained,
					cardCornerRadius = cornerRadius
				})
			else
				local createElement4 = React.createElement
				local v40 = if props.thumbnailBackgroundStyle then props.thumbnailBackgroundStyle.Color3 or nil else nil
				local v39 = {
					BackgroundColor3 = v40,
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

				local v41 = if isContained then Enum.ScaleType.Tile else nil
				v39.ScaleType = v41
				local v42 = if isContained then UDim2.new(1, 0, 1, -cornerRadius) else nil
				v39.TileSize = v42
				v21 = createElement4(loadableImage, v39)
			end
		else
			v21 = nil
		end
	end

	local v36 = {
		BackgroundImage = v37,
		Thumbnail = v21,
		UIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = v7 or 1
		}),
		ThumbnailOverlay = props.thumbnailOverlayComponent,
		OverflowMenu = 0,
		HoverOverlay = 0
	}
	local v38 = if fFlagLuaAppSduiGameTileFeedback then props.thumbnailOverflowMenuComponent else nil
	v36.OverflowMenu = v38

	local v39 = if state2 and not state then React.createElement("Frame", {
		BackgroundColor3 = v6.Color.State.Hover.Color3,
		BackgroundTransparency = v6.Color.State.Hover.Transparency,
		Size = UDim2.new(1, 0, 1, not isContained and 0 or cornerRadius)
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, cornerRadius)
		})
	}) else nil
	v36.HoverOverlay = v39
	children.ImageFrame = createElement3("Frame", v34, v36)

	local createElement4 = React.createElement

	local v41 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		LayoutOrder = 2,
		ZIndex = 1
	}

	local v44 = if isContained and not v9 then React.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, containmentPadding),
		PaddingRight = UDim.new(0, containmentPadding),
		PaddingBottom = UDim.new(0, containmentPadding)
	}) else nil
	local v43 = {
		["UIPadding"] = nil,
		["UIPadding"] = nil,
		["UIPadding"] = nil,
		UIPadding = v44,
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.Name,
			HorizontalFlex = Enum.UIFlexAlignment.Fill
		})
	}
	local v45

	if props.titleComponent then
		v45 = props.titleComponent
	elseif props.titleText and props.titleText ~= "" then
		v45 = React.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 0, v8),
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
			AutomaticSize = v9 and Enum.AutomaticSize.X or nil
		})
	end

	v43["1_Title"] = v45

	local v46 = if props.footerComponent then props.footerComponent else nil
	v43["2_Footer"] = v46
	local v47

	if props.bottomButtonComponent then
		v47 = React.createElement("Frame", {
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
				PaddingTop = UDim.new(0, props.bottomButtonGap or v6.Gap.Small)
			}),
			Content = props.bottomButtonComponent
		})
	end

	v43["3_BottomButton"] = v47

	local v48 = if not (fFlagSduiTileDisableLegacyHover or not (v20 and props.renderLegacyHoverState)) then React.createElement(
		"Frame",
		{ Size = UDim2.new(1, 0, 0, 0), ZIndex = -1 },
		{
			ExtraOverflow = props.renderLegacyHoverState(containmentPadding2, v11, cornerRadius)
		}
	) else nil
	v43.Z_3_ExtraOverflow = v48
	children.BottomContent = createElement4(
		"Frame",
		v41,
		maybeLayoutForButton(
			v43,
			props.ctaButtonComponent,
			v6.Gap.Small,
			not isContained and 0 or containmentPadding,
			v20
		)
	)

	local v49 = if props.focusNavActionsComponent or props.children then React.createElement(
		React.Fragment,
		nil,
		Cryo.Dictionary.join(props.children or v5, {
			focusNavActions = props.focusNavActionsComponent
		})
	) else nil
	children.ExtraChildren = v49

	local v50 = if v16 and v16.holdDetectorProps then React.createElement(holdDetector, v16.holdDetectorProps) else nil
	children.HoldDetector = v50
	return createElement("TextButton", v23, children)
end

return React.memo(SduiTile)
