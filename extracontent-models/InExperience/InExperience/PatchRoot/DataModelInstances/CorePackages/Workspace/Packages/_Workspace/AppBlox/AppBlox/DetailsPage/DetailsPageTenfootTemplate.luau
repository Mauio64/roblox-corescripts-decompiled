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

local function DetailsPageTenfootTemplate(t3: {[any]: any}) -- line: 163
	-- upvalues: t2 (copy), Cryo (copy), React (copy), getPlatformConfig (copy), Signal (copy), useAnimateFullscreen (copy), DetailsPageHeader (copy), useDetailsPageRenderItems (copy), DetailsPageRenderItem (copy), FFlagExtendScrollingFramesBySafeInsets (copy), useSignalState (copy), Display (copy), FFlagEnableLeftNavOnConsole (copy), FullscreenFrame (copy), FFlagLuaAppEdpConsoleMediaGalleryVideo (copy), LoadableImage (copy), Overlay (copy), AnimatedFlatList (copy), v20 (copy)
	local u27 = t2

	if t3.tokens then
		u27 = Cryo.Dictionary.join(u27, t3.tokens)
	end

	local v28, v29 = React.useState(true)
	local v30 = React.useMemo(function() -- line: 174
		-- upvalues: getPlatformConfig (copy), t3 (copy)
		return getPlatformConfig(t3.deviceType)
	end, { t3.deviceType })
	local v31 = React.useRef(nil)
	local v32, v33 = React.useState(Vector2.new(0, 0))
	local v34 = React.useCallback(function(p1) -- line: 180
		-- upvalues: v33 (copy)
		v33(p1.AbsoluteSize)
	end, {})

	React.useEffect(function() -- line: 183
		-- upvalues: v31 (copy), v33 (copy)
		if v31.current then
			v33(v31.current.AbsoluteSize)
		end
	end, {})

	local v35 = if not t3.thumbnailHeight then v30.thumbnailHeight else t3.thumbnailHeight
	local v36 = if t3.headerBarBackgroundHeight == nil then v30.headerBarBackgroundHeight else t3.headerBarBackgroundHeight
	local v37 = if not t3.sideMargin then v30.sideMargin else t3.sideMargin
	local v38 = React.useMemo(function() -- line: 195
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v39 = t3.isFullscreen ~= nil and t3.isFullscreen
	local renderFullscreenContent = t3.renderFullscreenContent
	local v41, v42 = useAnimateFullscreen(v39, renderFullscreenContent, u27.animationConfig)
	local v43 = React.useMemo(function() -- line: 207
		-- upvalues: React (copy), DetailsPageHeader (copy), t3 (copy), v35 (copy), v38 (copy), v37 (copy), v36 (copy), u27 (ref)
		return React.createElement(DetailsPageHeader, {
			thumbnailImageUrl = t3.thumbnailImageUrl,
			thumbnailAspectRatio = t3.thumbnailAspectRatio,
			thumbnailHeight = v35,
			titleText = t3.titleText,
			subTitleText = t3.subTitleText,
			actionBarLabelText = t3.actionBarLabelText,
			renderActionBarLabelImpressionsDetector = t3.renderActionBarLabelImpressionsDetector,
			scrollViewPositionChangedSignal = v38,
			renderInfoContent = t3.renderInfoContent,
			actionBarProps = t3.actionBarProps,
			sideMargin = v37,
			headerBarBackgroundHeight = v36,
			deviceType = t3.deviceType,
			thumbnailShadowHeight = u27.thumbnailShadowHeight,
			gradientHeight = u27.headerGradientHeight,
			actionBarHeight = u27.actionBarHeight,
			actionBarWidth = u27.actionBarWidth,
			itemPadding = u27.thumbnailMargin,
			bottomMargin = u27.headerBottomMargin
		})
	end, {
		t3.thumbnailImageUrl,
		t3.thumbnailAspectRatio,
		v35,
		t3.titleText,
		t3.subTitleText,
		t3.actionBarLabelText,
		t3.renderInfoContent,
		t3.actionBarProps,
		v37,
		v36,
		t3.deviceType,
		u27.thumbnailShadowHeight,
		u27.headerGradientHeight,
		u27.thumbnailMargin,
		u27.headerBottomMargin,
		u27.actionBarHeight,
		u27.actionBarWidth,
		t3.renderActionBarLabelImpressionsDetector,
		v38
	})
	local v44 = useDetailsPageRenderItems(t3.componentList, v43, v32, u27.safeAreaSize)
	local v45 = React.useCallback(function(p2) -- line: 257
		-- upvalues: React (copy), DetailsPageRenderItem (copy), u27 (ref)
		return React.createElement(DetailsPageRenderItem, {
			item = p2.item,
			itemPadding = u27.itemPadding,
			safeArea = u27.safeAreaSize
		})
	end, {
		u27.itemPadding,
		u27.safeAreaSize
	})
	local v46 = React.useCallback(function() -- line: 265
		-- upvalues: React (copy), u27 (ref)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, u27.itemPadding)
		})
	end, { u27.itemPadding })
	local v47 = React.useCallback(function(p3) -- line: 274
		-- upvalues: v38 (copy), v44 (copy), v29 (copy)
		v38:fire()

		if v44[p3].showCornerGradient == false then
			v29(false)

			return
		end

		v29(true)
	end, {
		v44,
		v38
	})
	local v48 = if not FFlagExtendScrollingFramesBySafeInsets then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return React.createElement(not FFlagEnableLeftNavOnConsole and "Frame" or FullscreenFrame, {
		[React.Change.AbsoluteSize] = v34,
		Size = if not FFlagEnableLeftNavOnConsole then UDim2.fromScale(1, 1) else nil,
		BackgroundTransparency = 1,
		ref = v31
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
			showGradient = v28
		}),
		Content = React.createElement(AnimatedFlatList, {
			animated = true,
			UNSTABLE_forceSiblingLayoutUpdate = true,
			onSelectedIndexChanged = v47,
			initialNumToRender = #v44,
			data = v44,
			renderItem = v45,
			ItemSeparatorComponent = v46,
			ListFooterComponent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, u27.trailingWhitespace)
			}),
			ListHeaderComponent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, u27.safeAreaSize.Y)
			}),
			viewOffset = u27.safeAreaSize.Y,
			contentContainerStyle = {
				BackgroundTransparency = 1
			},
			style = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				ScrollingEnabled = true,
				Selectable = false,
				ZIndex = 3,
				Position = if not FFlagEnableLeftNavOnConsole then nil else UDim2.fromOffset(0, -v48.top),
				Size = if not FFlagExtendScrollingFramesBySafeInsets and not FFlagEnableLeftNavOnConsole then nil else UDim2.new(1, 0, 1, v48.top + v48.bottom),
				VerticalScrollBarInset = Enum.ScrollBarInset.None
			},
			animationConfig = u27.animationConfig,
			overrideAutomaticCanvasSize = not FFlagEnableLeftNavOnConsole,
			isSequentiallySelectable = not not v20 or nil
		}),
		Fullscreen = React.createElement("CanvasGroup", {
			BorderSizePixel = 0,
			ZIndex = 4,
			Size = UDim2.fromScale(1, 1),
			GroupTransparency = v42
		}, {
			FullscreenContent = if not v41 then nil else renderFullscreenContent()
		})
	})
end

return DetailsPageTenfootTemplate
