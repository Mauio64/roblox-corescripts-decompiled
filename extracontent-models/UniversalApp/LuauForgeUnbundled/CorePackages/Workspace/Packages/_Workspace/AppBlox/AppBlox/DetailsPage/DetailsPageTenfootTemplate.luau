local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Cryo")
local animatedFlatList = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/VirtualizedList").AnimatedFlatList

local DetailsPageHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/DetailsPageHeader")
local getPlatformConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/getPlatformConfig")
local useDetailsPageRenderItems = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/Hooks/useDetailsPageRenderItems")
local useAnimateFullscreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/Hooks/useAnimateFullscreen")
local DetailsPageRenderItem = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/DetailsPageRenderItem")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Display")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SignalsReact").useSignalState
local FullscreenFrame = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/FullscreenFrame")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppCommonLib").Signal

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")
local overlay = UIBlox.App.Dialog.Overlay
local loadableImage = UIBlox.App.Loading.LoadableImage

require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppEnums")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/ReactOtter")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPage/Types")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")

local fFlagLuaAppEdpConsoleMediaGalleryVideo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/SharedFlags").FFlagLuaAppEdpConsoleMediaGalleryVideo

local v5 = {
	animationConfig = { dampingRatio = 1, frequency = 3 },
	itemPadding = 36,
	safeAreaSize = Vector2.new(96, 144),
	trailingWhitespace = 3000
}

local function DetailsPageTenfootTemplate(props)
	local joined = v5

	if props.tokens then
		joined = Cryo.Dictionary.join(joined, props.tokens)
	end

	local state, setState = React.useState(true)

	local v6 = React.useMemo(function()
		return getPlatformConfig(props.deviceType)
	end, { props.deviceType })

	local ref = React.useRef(nil)
	local state2, setState2 = React.useState(Vector2.new(0, 0))
	local v7 = React.useCallback(function(p2)
		setState2(p2.AbsoluteSize)
	end, {})
	React.useEffect(function()
		if ref.current then
			setState2(ref.current.AbsoluteSize)
		end
	end, {})

	local thumbnailHeight = if props.thumbnailHeight then props.thumbnailHeight else v6.thumbnailHeight
	local headerBarBackgroundHeight

	if props.headerBarBackgroundHeight == nil then
		headerBarBackgroundHeight = v6.headerBarBackgroundHeight
	else
		headerBarBackgroundHeight = props.headerBarBackgroundHeight
	end

	local sideMargin = if props.sideMargin then props.sideMargin else v6.sideMargin

	local v8 = React.useMemo(function()
		return signal.new()
	end, {})

	local v9 = not (props.isFullscreen == nil) and props.isFullscreen
	local renderFullscreenContent = props.renderFullscreenContent

	local v10, v11 = useAnimateFullscreen(v9, renderFullscreenContent, joined.animationConfig)

	local v12 = React.useMemo(function()
		return React.createElement(DetailsPageHeader, {
			thumbnailImageUrl = props.thumbnailImageUrl,
			thumbnailAspectRatio = props.thumbnailAspectRatio,
			thumbnailHeight = thumbnailHeight,
			titleText = props.titleText,
			subTitleText = props.subTitleText,
			actionBarLabelText = props.actionBarLabelText,
			renderActionBarLabelImpressionsDetector = props.renderActionBarLabelImpressionsDetector,
			scrollViewPositionChangedSignal = v8,
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
		v8
	})

	local v13 = useDetailsPageRenderItems(props.componentList, v12, state2, joined.safeAreaSize)

	local v14 = React.useCallback(function(p2)
		return React.createElement(DetailsPageRenderItem, {
			item = p2.item,
			itemPadding = joined.itemPadding,
			safeArea = joined.safeAreaSize
		})
	end, { joined.itemPadding, joined.safeAreaSize })

	local v15 = React.useCallback(function()
		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, joined.itemPadding),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		})
	end, { joined.itemPadding })

	local v16 = React.useCallback(function(p2)
		v8:fire()

		if v13[p2].showCornerGradient == false then
			setState(false)
		else
			setState(true)
		end
	end, { v13, v8 })

	local v17 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	local createElement = React.createElement
	local v19 = {
		[React.Change.AbsoluteSize] = v7,
		BackgroundTransparency = 1,
		ref = ref
	}

	local createElement2 = React.createElement
	local v21 = { ZIndex = 1, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

	local v23 = if not fFlagLuaAppEdpConsoleMediaGalleryVideo then React.createElement(loadableImage, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 1, 0),
		Image = props.bannerImageUrl,
		ScaleType = Enum.ScaleType.Crop
	}) else nil
	local v24

	if fFlagLuaAppEdpConsoleMediaGalleryVideo then
		if props.backgroundContentOverride then
			v24 = props.backgroundContentOverride
		else
			v24 = React.createElement(loadableImage, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0),
				Image = props.bannerImageUrl,
				ScaleType = Enum.ScaleType.Crop
			})
		end
	end

	local children = {
		BackgroundImage = createElement2("Frame", v21, {
			BackgroundImage = v23,
			BackgroundContent = v24
		}),
		Overlay = React.createElement(overlay, {
			ZIndex = 2,
			showGradient = state,
			gradientDirection = "topRight"
		}),
		Content = React.createElement(animatedFlatList, {
			onSelectedIndexChanged = v16,
			animated = true,
			initialNumToRender = #v13,
			data = v13,
			renderItem = v14,
			ItemSeparatorComponent = v15,
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
				Position = UDim2.fromOffset(0, -v17.top),
				Size = UDim2.new(1, 0, 1, v17.top + v17.bottom),
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
	local v26 = {
		Size = UDim2.fromScale(1, 1),
		GroupTransparency = v11,
		BorderSizePixel = 0,
		ZIndex = 4
	}

	local v28 = if v10 then renderFullscreenContent() else nil
	children.Fullscreen = createElement3("CanvasGroup", v26, { FullscreenContent = v28 })
	return createElement(FullscreenFrame, v19, children)
end

return DetailsPageTenfootTemplate
