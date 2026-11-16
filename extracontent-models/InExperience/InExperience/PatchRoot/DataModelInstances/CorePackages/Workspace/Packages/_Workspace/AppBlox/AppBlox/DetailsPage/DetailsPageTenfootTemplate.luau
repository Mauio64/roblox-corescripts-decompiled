local AppBlox = script:FindFirstAncestor("AppBlox")
local parent = AppBlox.Parent
local Cryo = require(parent.Cryo)
local VirtualizedList = require(parent.VirtualizedList)
local AnimatedFlatList = VirtualizedList.AnimatedFlatList

local DetailsPageHeader = require(script.Parent.DetailsPageHeader)
local getPlatformConfig = require(script.Parent.getPlatformConfig)
local useDetailsPageRenderItems = require(script.Parent.Hooks.useDetailsPageRenderItems)
local useAnimateFullscreen = require(script.Parent.Hooks.useAnimateFullscreen)
local DetailsPageRenderItem = require(script.Parent.DetailsPageRenderItem)
local Display = require(parent.Display)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local FullscreenFrame = require(AppBlox.FullscreenFrame)
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

local UIBlox = require(parent.UIBlox)
local Overlay = UIBlox.App.Dialog.Overlay
local LoadableImage = UIBlox.App.Loading.LoadableImage

require(parent.RobloxAppEnums)

require(parent.ReactOtter)

require(script.Parent.Types)

local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEdpConsoleMediaGalleryVideo = SharedFlags.FFlagLuaAppEdpConsoleMediaGalleryVideo

local v = {
	animationConfig = { dampingRatio = 1, frequency = 3 },
	itemPadding = 36,
	safeAreaSize = Vector2.new(96, 144),
	trailingWhitespace = 3000
}

local function DetailsPageTenfootTemplate(props)
	local joined = v

	if props.tokens then
		joined = Cryo.Dictionary.join(joined, props.tokens)
	end

	local state, setState = React.useState(true)

	local v2 = React.useMemo(function()
		return getPlatformConfig(props.deviceType)
	end, { props.deviceType })

	local ref = React.useRef(nil)
	local state2, setState2 = React.useState(Vector2.new(0, 0))
	local v3 = React.useCallback(function(p)
		setState2(p.AbsoluteSize)
	end, {})
	React.useEffect(function()
		if ref.current then
			setState2(ref.current.AbsoluteSize)
		end
	end, {})
	local thumbnailHeight

	if props.thumbnailHeight then
		thumbnailHeight = props.thumbnailHeight
	else
		thumbnailHeight = v2.thumbnailHeight
	end

	local headerBarBackgroundHeight

	if props.headerBarBackgroundHeight == nil then
		headerBarBackgroundHeight = v2.headerBarBackgroundHeight
	else
		headerBarBackgroundHeight = props.headerBarBackgroundHeight
	end

	local sideMargin

	if props.sideMargin then
		sideMargin = props.sideMargin
	else
		sideMargin = v2.sideMargin
	end

	local scrollViewPositionChangedSignal = React.useMemo(function()
		return Signal.new()
	end, {})

	local v4 = not (props.isFullscreen == nil) and props.isFullscreen
	local renderFullscreenContent = props.renderFullscreenContent

	local v5, groupTransparency = useAnimateFullscreen(v4, renderFullscreenContent, joined.animationConfig)

	local v6 = React.useMemo(function()
		return React.createElement(DetailsPageHeader, {
			thumbnailImageUrl = props.thumbnailImageUrl,
			thumbnailAspectRatio = props.thumbnailAspectRatio,
			thumbnailHeight = thumbnailHeight,
			titleText = props.titleText,
			subTitleText = props.subTitleText,
			actionBarLabelText = props.actionBarLabelText,
			renderActionBarLabelImpressionsDetector = props.renderActionBarLabelImpressionsDetector,
			scrollViewPositionChangedSignal = scrollViewPositionChangedSignal,
			renderInfoContent = props.renderInfoContent,
			actionBarProps = props.actionBarProps,
			sideMargin = sideMargin,
			headerBarBackgroundHeight = headerBarBackgroundHeight,
			deviceType = props.deviceType,
			thumbnailShadowHeight = joined.thumbnailShadowHeight,
			gradientHeight = joined.headerGradientHeight,
			actionBarHeight = joined.actionBarHeight,
			actionBarWidth = props.actionBarWidth or joined.actionBarWidth,
			itemPadding = joined.thumbnailMargin,
			bottomMargin = joined.headerBottomMargin
		})
	end, {
		props.thumbnailImageUrl,
		props.thumbnailAspectRatio,
		thumbnailHeight,
		props.titleText,
		props.subTitleText,
		props.actionBarLabelText,
		props.renderInfoContent,
		props.actionBarProps,
		sideMargin,
		headerBarBackgroundHeight,
		props.deviceType,
		joined.thumbnailShadowHeight,
		joined.headerGradientHeight,
		joined.thumbnailMargin,
		joined.headerBottomMargin,
		joined.actionBarHeight,
		joined.actionBarWidth,
		props.actionBarWidth,
		props.renderActionBarLabelImpressionsDetector,
		scrollViewPositionChangedSignal
	})

	local v7 = useDetailsPageRenderItems(props.componentList, v6, state2, joined.safeAreaSize)

	local renderItem = React.useCallback(function(p)
		return React.createElement(DetailsPageRenderItem, {
			item = p.item,
			itemPadding = joined.itemPadding,
			safeArea = joined.safeAreaSize
		})
	end, { joined.itemPadding, joined.safeAreaSize })

	local itemSeparatorComponent = React.useCallback(function()
		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, joined.itemPadding),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		})
	end, { joined.itemPadding })

	local onSelectedIndexChanged = React.useCallback(function(p)
		scrollViewPositionChangedSignal:fire()

		if v7[p].showCornerGradient == false then
			setState(false)
		else
			setState(true)
		end
	end, { v7, scrollViewPositionChangedSignal })

	local v8 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	local createElement = React.createElement
	local v9 = { [React.Change.AbsoluteSize] = v3, BackgroundTransparency = 1, ref = ref }

	local createElement2 = React.createElement
	local v10 = { ZIndex = 1, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }
	local backgroundImage

	if not FFlagLuaAppEdpConsoleMediaGalleryVideo then
		backgroundImage = React.createElement(LoadableImage, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, 0),
			Image = props.bannerImageUrl,
			ScaleType = Enum.ScaleType.Crop
		})
	end

	local backgroundContent

	if FFlagLuaAppEdpConsoleMediaGalleryVideo then
		if props.backgroundContentOverride then
			backgroundContent = props.backgroundContentOverride
		else
			backgroundContent = React.createElement(LoadableImage, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0),
				Image = props.bannerImageUrl,
				ScaleType = Enum.ScaleType.Crop
			})
		end
	end

	local children = {
		BackgroundImage = createElement2("Frame", v10, {
			BackgroundImage = backgroundImage,
			BackgroundContent = backgroundContent
		}),
		Overlay = React.createElement(Overlay, {
			ZIndex = 2,
			showGradient = state,
			gradientDirection = "topRight"
		}),
		Content = React.createElement(AnimatedFlatList, {
			onSelectedIndexChanged = onSelectedIndexChanged,
			animated = true,
			initialNumToRender = #v7,
			data = v7,
			renderItem = renderItem,
			ItemSeparatorComponent = itemSeparatorComponent,
			ListFooterComponent = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, joined.trailingWhitespace),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}),
			ListHeaderComponent = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, joined.safeAreaSize.Y),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}),
			viewOffset = joined.safeAreaSize.Y,
			contentContainerStyle = { BackgroundTransparency = 1 },
			style = {
				Position = UDim2.fromOffset(0, -v8.top),
				Size = UDim2.new(1, 0, 1, v8.top + v8.bottom),
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				ScrollingEnabled = true,
				Selectable = false,
				VerticalScrollBarInset = Enum.ScrollBarInset.None,
				ZIndex = 3
			},
			animationConfig = joined.animationConfig,
			UNSTABLE_forceSiblingLayoutUpdate = true,
			overrideAutomaticCanvasSize = false,
			isSequentiallySelectable = true
		}),
		Fullscreen = 0
	}

	local createElement3 = React.createElement
	local v11 = {
		Size = UDim2.fromScale(1, 1),
		GroupTransparency = groupTransparency,
		BorderSizePixel = 0,
		ZIndex = 4
	}
	local fullscreenContent

	if v5 then
		fullscreenContent = renderFullscreenContent()
	end

	children.Fullscreen = createElement3("CanvasGroup", v11, {
		FullscreenContent = fullscreenContent
	})
	return createElement(FullscreenFrame, v9, children)
end

return DetailsPageTenfootTemplate
