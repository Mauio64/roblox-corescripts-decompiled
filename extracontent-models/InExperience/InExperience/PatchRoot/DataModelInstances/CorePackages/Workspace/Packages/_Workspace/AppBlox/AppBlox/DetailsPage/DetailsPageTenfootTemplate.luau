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
local v23 = game:DefineFastFlag("FixDeviceSafePaddingAccess", false)
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

local function DetailsPageTenfootTemplate(t3: {[any]: any}) -- line: 165
	-- upvalues: t2 (copy), Cryo (copy), React (copy), getPlatformConfig (copy), Signal (copy), useAnimateFullscreen (copy), DetailsPageHeader (copy), FFlagLuaAppDemoModePlayButton (copy), useDetailsPageRenderItems (copy), DetailsPageRenderItem (copy), v23 (copy), FFlagEnableLeftNavOnConsole (copy), FFlagExtendScrollingFramesBySafeInsets (copy), useSignalState (copy), Display (copy), FullscreenFrame (copy), FFlagLuaAppEdpConsoleMediaGalleryVideo (copy), LoadableImage (copy), Overlay (copy), AnimatedFlatList (copy), v20 (copy)
	local u29 = t2

	if t3.tokens then
		u29 = Cryo.Dictionary.join(u29, t3.tokens)
	end

	local v30, v31 = React.useState(true)
	local v32 = React.useMemo(function() -- line: 176
		-- upvalues: getPlatformConfig (copy), t3 (copy)
		return getPlatformConfig(t3.deviceType)
	end, { t3.deviceType })
	local v33 = React.useRef(nil)
	local v34, v35 = React.useState(Vector2.new(0, 0))
	local v36 = React.useCallback(function(p1) -- line: 182
		-- upvalues: v35 (copy)
		v35(p1.AbsoluteSize)
	end, {})

	React.useEffect(function() -- line: 185
		-- upvalues: v33 (copy), v35 (copy)
		if v33.current then
			v35(v33.current.AbsoluteSize)
		end
	end, {})

	local v37 = if not t3.thumbnailHeight then v32.thumbnailHeight else t3.thumbnailHeight
	local v38 = if t3.headerBarBackgroundHeight == nil then v32.headerBarBackgroundHeight else t3.headerBarBackgroundHeight
	local v39 = if not t3.sideMargin then v32.sideMargin else t3.sideMargin
	local v40 = React.useMemo(function() -- line: 197
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v41 = t3.isFullscreen ~= nil and t3.isFullscreen
	local renderFullscreenContent = t3.renderFullscreenContent
	local v43, v44 = useAnimateFullscreen(v41, renderFullscreenContent, u29.animationConfig)
	local v45 = React.useMemo(function() -- line: 209
		-- upvalues: React (copy), DetailsPageHeader (copy), t3 (copy), v37 (copy), v40 (copy), v39 (copy), v38 (copy), u29 (ref), FFlagLuaAppDemoModePlayButton (copy)
		return React.createElement(DetailsPageHeader, {
			thumbnailImageUrl = t3.thumbnailImageUrl,
			thumbnailAspectRatio = t3.thumbnailAspectRatio,
			thumbnailHeight = v37,
			titleText = t3.titleText,
			subTitleText = t3.subTitleText,
			actionBarLabelText = t3.actionBarLabelText,
			renderActionBarLabelImpressionsDetector = t3.renderActionBarLabelImpressionsDetector,
			scrollViewPositionChangedSignal = v40,
			renderInfoContent = t3.renderInfoContent,
			actionBarProps = t3.actionBarProps,
			sideMargin = v39,
			headerBarBackgroundHeight = v38,
			deviceType = t3.deviceType,
			thumbnailShadowHeight = u29.thumbnailShadowHeight,
			gradientHeight = u29.headerGradientHeight,
			actionBarHeight = u29.actionBarHeight,
			actionBarWidth = if not FFlagLuaAppDemoModePlayButton then u29.actionBarWidth else t3.actionBarWidth or u29.actionBarWidth,
			itemPadding = u29.thumbnailMargin,
			bottomMargin = u29.headerBottomMargin
		})
	end, {
		t3.thumbnailImageUrl,
		t3.thumbnailAspectRatio,
		v37,
		t3.titleText,
		t3.subTitleText,
		t3.actionBarLabelText,
		t3.renderInfoContent,
		t3.actionBarProps,
		v39,
		v38,
		t3.deviceType,
		u29.thumbnailShadowHeight,
		u29.headerGradientHeight,
		u29.thumbnailMargin,
		u29.headerBottomMargin,
		u29.actionBarHeight,
		u29.actionBarWidth,
		if not FFlagLuaAppDemoModePlayButton then nil else t3.actionBarWidth,
		t3.renderActionBarLabelImpressionsDetector,
		v40
	})
	local v46 = useDetailsPageRenderItems(t3.componentList, v45, v34, u29.safeAreaSize)
	local v47 = React.useCallback(function(p2) -- line: 262
		-- upvalues: React (copy), DetailsPageRenderItem (copy), u29 (ref)
		return React.createElement(DetailsPageRenderItem, {
			item = p2.item,
			itemPadding = u29.itemPadding,
			safeArea = u29.safeAreaSize
		})
	end, {
		u29.itemPadding,
		u29.safeAreaSize
	})
	local v48 = React.useCallback(function() -- line: 270
		-- upvalues: React (copy), u29 (ref)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, u29.itemPadding)
		})
	end, { u29.itemPadding })
	local v49 = React.useCallback(function(p3) -- line: 279
		-- upvalues: v40 (copy), v46 (copy), v31 (copy)
		v40:fire()

		if v46[p3].showCornerGradient == false then
			v31(false)

			return
		end

		v31(true)
	end, {
		v46,
		v40
	})
	local v50 = if not v23 then if not FFlagExtendScrollingFramesBySafeInsets then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding) else if not FFlagEnableLeftNavOnConsole and not FFlagExtendScrollingFramesBySafeInsets then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return React.createElement(not FFlagEnableLeftNavOnConsole and "Frame" or FullscreenFrame, {
		[React.Change.AbsoluteSize] = v36,
		Size = if not FFlagEnableLeftNavOnConsole then UDim2.fromScale(1, 1) else nil,
		BackgroundTransparency = 1,
		ref = v33
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
			showGradient = v30
		}),
		Content = React.createElement(AnimatedFlatList, {
			animated = true,
			UNSTABLE_forceSiblingLayoutUpdate = true,
			onSelectedIndexChanged = v49,
			initialNumToRender = #v46,
			data = v46,
			renderItem = v47,
			ItemSeparatorComponent = v48,
			ListFooterComponent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, u29.trailingWhitespace)
			}),
			ListHeaderComponent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, u29.safeAreaSize.Y)
			}),
			viewOffset = u29.safeAreaSize.Y,
			contentContainerStyle = {
				BackgroundTransparency = 1
			},
			style = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				ScrollingEnabled = true,
				Selectable = false,
				ZIndex = 3,
				Position = if not FFlagEnableLeftNavOnConsole then nil else UDim2.fromOffset(0, -v50.top),
				Size = if not FFlagExtendScrollingFramesBySafeInsets and not FFlagEnableLeftNavOnConsole then nil else UDim2.new(1, 0, 1, v50.top + v50.bottom),
				VerticalScrollBarInset = Enum.ScrollBarInset.None
			},
			animationConfig = u29.animationConfig,
			overrideAutomaticCanvasSize = not FFlagEnableLeftNavOnConsole,
			isSequentiallySelectable = not not v20 or nil
		}),
		Fullscreen = React.createElement("CanvasGroup", {
			BorderSizePixel = 0,
			ZIndex = 4,
			Size = UDim2.fromScale(1, 1),
			GroupTransparency = v44
		}, {
			FullscreenContent = if not v43 then nil else renderFullscreenContent()
		})
	})
end

return DetailsPageTenfootTemplate
