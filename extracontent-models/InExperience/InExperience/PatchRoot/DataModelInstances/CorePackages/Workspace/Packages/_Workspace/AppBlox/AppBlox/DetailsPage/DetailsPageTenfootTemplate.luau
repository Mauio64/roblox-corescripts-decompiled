local AppBlox = script:FindFirstAncestor("AppBlox")
local AppBloxParent = AppBlox.Parent
local Cryo = require(AppBloxParent.Cryo)
local AnimatedFlatList = require(AppBloxParent.VirtualizedList).AnimatedFlatList
local DetailsPageHeader = require(script.Parent.DetailsPageHeader)
local getPlatformConfig = require(script.Parent.getPlatformConfig)
local useDetailsPageRenderItems = require(script.Parent.Hooks.useDetailsPageRenderItems)
local useAnimateFullscreen = require(script.Parent.Hooks.useAnimateFullscreen)
local DetailsPageRenderItem = require(script.Parent.DetailsPageRenderItem)
local Display = require(AppBloxParent.Display)
local useSignalState = require(AppBloxParent.SignalsReact).useSignalState
local FullscreenFrame = require(AppBlox.FullscreenFrame)
local Signal = require(AppBloxParent.AppCommonLib).Signal
local UIBlox = require(AppBloxParent.UIBlox)
local Overlay = UIBlox.App.Dialog.Overlay
local LoadableImage = UIBlox.App.Loading.LoadableImage

require(AppBloxParent.RobloxAppEnums)
require(AppBloxParent.ReactOtter)
require(script.Parent.Types)

local React = require(AppBloxParent.React)
local FFlagExtendScrollingFramesBySafeInsets = require(AppBloxParent.SharedFlags).FFlagExtendScrollingFramesBySafeInsets
local FFlagEnableLeftNavOnConsole = require(AppBloxParent.SharedFlags).FFlagEnableLeftNavOnConsole
local v20 = game:DefineFastFlag("FixConsoleEDPDirectionalNavigation", false)
local FFlagLuaAppEdpConsoleMediaGalleryVideo = require(AppBloxParent.SharedFlags).FFlagLuaAppEdpConsoleMediaGalleryVideo
local FFlagLuaAppDemoModePlayButton = require(AppBloxParent.SharedFlags).FFlagLuaAppDemoModePlayButton
local vector2 = Vector2.new(96, 144)
local t1 = {
	dampingRatio = 1,
	frequency = 3
}
local t2 = {
	itemPadding = 36,
	trailingWhitespace = 3000,
	animationConfig = t1,
	safeAreaSize = vector2
}

local function DetailsPageTenfootTemplate(t3: {[any]: any}) -- line: 164
	-- upvalues: t2 (copy), Cryo (copy), React (copy), getPlatformConfig (copy), Signal (copy), useAnimateFullscreen (copy), DetailsPageHeader (copy), FFlagLuaAppDemoModePlayButton (copy), useDetailsPageRenderItems (copy), DetailsPageRenderItem (copy), FFlagExtendScrollingFramesBySafeInsets (copy), useSignalState (copy), Display (copy), FFlagEnableLeftNavOnConsole (copy), FullscreenFrame (copy), FFlagLuaAppEdpConsoleMediaGalleryVideo (copy), LoadableImage (copy), Overlay (copy), AnimatedFlatList (copy), v20 (copy)
	local u28 = t2

	if t3.tokens then
		u28 = Cryo.Dictionary.join(u28, t3.tokens)
	end

	local v29, v30 = React.useState(true)
	local v31 = React.useMemo(function() -- line: 175
		-- upvalues: getPlatformConfig (copy), t3 (copy)
		return getPlatformConfig(t3.deviceType)
	end, { t3.deviceType })
	local v32 = React.useRef(nil)
	local v33, v34 = React.useState(Vector2.new(0, 0))
	local v35 = React.useCallback(function(p1) -- line: 181
		-- upvalues: v34 (copy)
		v34(p1.AbsoluteSize)
	end, {})

	React.useEffect(function() -- line: 184
		-- upvalues: v32 (copy), v34 (copy)
		if v32.current then
			v34(v32.current.AbsoluteSize)
		end
	end, {})

	local v36 = if not t3.thumbnailHeight then v31.thumbnailHeight else t3.thumbnailHeight
	local v37 = if t3.headerBarBackgroundHeight == nil then v31.headerBarBackgroundHeight else t3.headerBarBackgroundHeight
	local v38 = if not t3.sideMargin then v31.sideMargin else t3.sideMargin
	local v39 = React.useMemo(function() -- line: 196
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v40 = t3.isFullscreen ~= nil and t3.isFullscreen
	local renderFullscreenContent = t3.renderFullscreenContent
	local v42, v43 = useAnimateFullscreen(v40, renderFullscreenContent, u28.animationConfig)
	local v44 = React.useMemo(function() -- line: 208
		-- upvalues: React (copy), DetailsPageHeader (copy), t3 (copy), v36 (copy), v39 (copy), v38 (copy), v37 (copy), u28 (ref), FFlagLuaAppDemoModePlayButton (copy)
		return React.createElement(DetailsPageHeader, {
			thumbnailImageUrl = t3.thumbnailImageUrl,
			thumbnailAspectRatio = t3.thumbnailAspectRatio,
			thumbnailHeight = v36,
			titleText = t3.titleText,
			subTitleText = t3.subTitleText,
			actionBarLabelText = t3.actionBarLabelText,
			renderActionBarLabelImpressionsDetector = t3.renderActionBarLabelImpressionsDetector,
			scrollViewPositionChangedSignal = v39,
			renderInfoContent = t3.renderInfoContent,
			actionBarProps = t3.actionBarProps,
			sideMargin = v38,
			headerBarBackgroundHeight = v37,
			deviceType = t3.deviceType,
			thumbnailShadowHeight = u28.thumbnailShadowHeight,
			gradientHeight = u28.headerGradientHeight,
			actionBarHeight = u28.actionBarHeight,
			actionBarWidth = if not FFlagLuaAppDemoModePlayButton then u28.actionBarWidth else t3.actionBarWidth or u28.actionBarWidth,
			itemPadding = u28.thumbnailMargin,
			bottomMargin = u28.headerBottomMargin
		})
	end, {
		t3.thumbnailImageUrl,
		t3.thumbnailAspectRatio,
		v36,
		t3.titleText,
		t3.subTitleText,
		t3.actionBarLabelText,
		t3.renderInfoContent,
		t3.actionBarProps,
		v38,
		v37,
		t3.deviceType,
		u28.thumbnailShadowHeight,
		u28.headerGradientHeight,
		u28.thumbnailMargin,
		u28.headerBottomMargin,
		u28.actionBarHeight,
		u28.actionBarWidth,
		if not FFlagLuaAppDemoModePlayButton then nil else t3.actionBarWidth,
		t3.renderActionBarLabelImpressionsDetector,
		v39
	})
	local v45 = useDetailsPageRenderItems(t3.componentList, v44, v33, u28.safeAreaSize)
	local v46 = React.useCallback(function(p2) -- line: 261
		-- upvalues: React (copy), DetailsPageRenderItem (copy), u28 (ref)
		return React.createElement(DetailsPageRenderItem, {
			item = p2.item,
			itemPadding = u28.itemPadding,
			safeArea = u28.safeAreaSize
		})
	end, {
		u28.itemPadding,
		u28.safeAreaSize
	})
	local v47 = React.useCallback(function() -- line: 269
		-- upvalues: React (copy), u28 (ref)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, u28.itemPadding)
		})
	end, { u28.itemPadding })
	local v48 = React.useCallback(function(p3) -- line: 278
		-- upvalues: v39 (copy), v45 (copy), v30 (copy)
		v39:fire()

		if v45[p3].showCornerGradient == false then
			v30(false)

			return
		end

		v30(true)
	end, {
		v45,
		v39
	})
	local v49 = if not FFlagExtendScrollingFramesBySafeInsets then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return React.createElement(not FFlagEnableLeftNavOnConsole and "Frame" or FullscreenFrame, {
		[React.Change.AbsoluteSize] = v35,
		Size = if not FFlagEnableLeftNavOnConsole then UDim2.fromScale(1, 1) else nil,
		BackgroundTransparency = 1,
		ref = v32
	}, {
		BackgroundImage = React.createElement("Frame", {
			ZIndex = 1,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			BackgroundImage = if not FFlagLuaAppEdpConsoleMediaGalleryVideo then React.createElement(LoadableImage, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0),
				Image = t3.bannerImageUrl,
				ScaleType = Enum.ScaleType.Crop
			}) else nil,
			BackgroundContent = if not FFlagLuaAppEdpConsoleMediaGalleryVideo then nil else if not t3.backgroundContentOverride then React.createElement(LoadableImage, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0),
				Image = t3.bannerImageUrl,
				ScaleType = Enum.ScaleType.Crop
			}) else t3.backgroundContentOverride
		}),
		Overlay = React.createElement(Overlay, {
			ZIndex = 2,
			gradientDirection = "topRight",
			showGradient = v29
		}),
		Content = React.createElement(AnimatedFlatList, {
			animated = true,
			UNSTABLE_forceSiblingLayoutUpdate = true,
			onSelectedIndexChanged = v48,
			initialNumToRender = #v45,
			data = v45,
			renderItem = v46,
			ItemSeparatorComponent = v47,
			ListFooterComponent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, u28.trailingWhitespace)
			}),
			ListHeaderComponent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, u28.safeAreaSize.Y)
			}),
			viewOffset = u28.safeAreaSize.Y,
			contentContainerStyle = {
				BackgroundTransparency = 1
			},
			style = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				ScrollingEnabled = true,
				Selectable = false,
				ZIndex = 3,
				Position = if not FFlagEnableLeftNavOnConsole then nil else UDim2.fromOffset(0, -v49.top),
				Size = if not FFlagExtendScrollingFramesBySafeInsets and not FFlagEnableLeftNavOnConsole then nil else UDim2.new(1, 0, 1, v49.top + v49.bottom),
				VerticalScrollBarInset = Enum.ScrollBarInset.None
			},
			animationConfig = u28.animationConfig,
			overrideAutomaticCanvasSize = not FFlagEnableLeftNavOnConsole,
			isSequentiallySelectable = not not v20 or nil
		}),
		Fullscreen = React.createElement("CanvasGroup", {
			BorderSizePixel = 0,
			ZIndex = 4,
			Size = UDim2.fromScale(1, 1),
			GroupTransparency = v43
		}, {
			FullscreenContent = if not v42 then nil else renderFullscreenContent()
		})
	})
end

return DetailsPageTenfootTemplate
