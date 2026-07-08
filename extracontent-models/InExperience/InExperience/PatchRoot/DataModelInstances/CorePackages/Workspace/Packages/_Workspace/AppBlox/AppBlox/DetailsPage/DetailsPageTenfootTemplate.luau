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

local function DetailsPageTenfootTemplate(t3: {[any]: any}) -- line: 159
	-- upvalues: t2 (copy), Cryo (copy), React (copy), getPlatformConfig (copy), Signal (copy), useAnimateFullscreen (copy), DetailsPageHeader (copy), useDetailsPageRenderItems (copy), DetailsPageRenderItem (copy), FFlagExtendScrollingFramesBySafeInsets (copy), useSignalState (copy), Display (copy), FFlagEnableLeftNavOnConsole (copy), FullscreenFrame (copy), LoadableImage (copy), Overlay (copy), AnimatedFlatList (copy), v20 (copy)
	local u26 = t2

	if t3.tokens then
		u26 = Cryo.Dictionary.join(u26, t3.tokens)
	end

	local v27, v28 = React.useState(true)
	local v29 = React.useMemo(function() -- line: 170
		-- upvalues: getPlatformConfig (copy), t3 (copy)
		return getPlatformConfig(t3.deviceType)
	end, { t3.deviceType })
	local v30 = React.useRef(nil)
	local v31, v32 = React.useState(Vector2.new(0, 0))
	local v33 = React.useCallback(function(p1) -- line: 176
		-- upvalues: v32 (copy)
		v32(p1.AbsoluteSize)
	end, {})

	React.useEffect(function() -- line: 179
		-- upvalues: v30 (copy), v32 (copy)
		if v30.current then
			v32(v30.current.AbsoluteSize)
		end
	end, {})

	local v34 = if not t3.thumbnailHeight then v29.thumbnailHeight else t3.thumbnailHeight
	local v35 = if t3.headerBarBackgroundHeight == nil then v29.headerBarBackgroundHeight else t3.headerBarBackgroundHeight
	local v36 = if not t3.sideMargin then v29.sideMargin else t3.sideMargin
	local v37 = React.useMemo(function() -- line: 191
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})
	local v38 = t3.isFullscreen ~= nil and t3.isFullscreen
	local renderFullscreenContent = t3.renderFullscreenContent
	local v40, v41 = useAnimateFullscreen(v38, renderFullscreenContent, u26.animationConfig)
	local v42 = React.useMemo(function() -- line: 203
		-- upvalues: React (copy), DetailsPageHeader (copy), t3 (copy), v34 (copy), v37 (copy), v36 (copy), v35 (copy), u26 (ref)
		return React.createElement(DetailsPageHeader, {
			thumbnailImageUrl = t3.thumbnailImageUrl,
			thumbnailAspectRatio = t3.thumbnailAspectRatio,
			thumbnailHeight = v34,
			titleText = t3.titleText,
			subTitleText = t3.subTitleText,
			actionBarLabelText = t3.actionBarLabelText,
			renderActionBarLabelImpressionsDetector = t3.renderActionBarLabelImpressionsDetector,
			scrollViewPositionChangedSignal = v37,
			renderInfoContent = t3.renderInfoContent,
			actionBarProps = t3.actionBarProps,
			sideMargin = v36,
			headerBarBackgroundHeight = v35,
			deviceType = t3.deviceType,
			thumbnailShadowHeight = u26.thumbnailShadowHeight,
			gradientHeight = u26.headerGradientHeight,
			actionBarHeight = u26.actionBarHeight,
			actionBarWidth = u26.actionBarWidth,
			itemPadding = u26.thumbnailMargin,
			bottomMargin = u26.headerBottomMargin
		})
	end, {
		t3.thumbnailImageUrl,
		t3.thumbnailAspectRatio,
		v34,
		t3.titleText,
		t3.subTitleText,
		t3.actionBarLabelText,
		t3.renderInfoContent,
		t3.actionBarProps,
		v36,
		v35,
		t3.deviceType,
		u26.thumbnailShadowHeight,
		u26.headerGradientHeight,
		u26.thumbnailMargin,
		u26.headerBottomMargin,
		u26.actionBarHeight,
		u26.actionBarWidth,
		t3.renderActionBarLabelImpressionsDetector,
		v37
	})
	local v43 = useDetailsPageRenderItems(t3.componentList, v42, v31, u26.safeAreaSize)
	local v44 = React.useCallback(function(p2) -- line: 253
		-- upvalues: React (copy), DetailsPageRenderItem (copy), u26 (ref)
		return React.createElement(DetailsPageRenderItem, {
			item = p2.item,
			itemPadding = u26.itemPadding,
			safeArea = u26.safeAreaSize
		})
	end, {
		u26.itemPadding,
		u26.safeAreaSize
	})
	local v45 = React.useCallback(function() -- line: 261
		-- upvalues: React (copy), u26 (ref)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, u26.itemPadding)
		})
	end, { u26.itemPadding })
	local v46 = React.useCallback(function(p3) -- line: 270
		-- upvalues: v37 (copy), v43 (copy), v28 (copy)
		v37:fire()

		if v43[p3].showCornerGradient == false then
			v28(false)

			return
		end

		v28(true)
	end, {
		v43,
		v37
	})
	local v47 = if not FFlagExtendScrollingFramesBySafeInsets then nil else useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	return React.createElement(not FFlagEnableLeftNavOnConsole and "Frame" or FullscreenFrame, {
		[React.Change.AbsoluteSize] = v33,
		Size = if not FFlagEnableLeftNavOnConsole then UDim2.fromScale(1, 1) else nil,
		BackgroundTransparency = 1,
		ref = v30
	}, {
		BackgroundImage = React.createElement("Frame", {
			ZIndex = 1,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1)
		}, {
			BackgroundImage = React.createElement(LoadableImage, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.new(1, 0, 1, 0),
				Image = t3.bannerImageUrl,
				ScaleType = Enum.ScaleType.Crop
			})
		}),
		Overlay = React.createElement(Overlay, {
			ZIndex = 2,
			gradientDirection = "topRight",
			showGradient = v27
		}),
		Content = React.createElement(AnimatedFlatList, {
			animated = true,
			UNSTABLE_forceSiblingLayoutUpdate = true,
			onSelectedIndexChanged = v46,
			initialNumToRender = #v43,
			data = v43,
			renderItem = v44,
			ItemSeparatorComponent = v45,
			ListFooterComponent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, u26.trailingWhitespace)
			}),
			ListHeaderComponent = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, u26.safeAreaSize.Y)
			}),
			viewOffset = u26.safeAreaSize.Y,
			contentContainerStyle = {
				BackgroundTransparency = 1
			},
			style = {
				BackgroundTransparency = 1,
				ScrollBarThickness = 0,
				ScrollingEnabled = true,
				Selectable = false,
				ZIndex = 3,
				Position = if not FFlagEnableLeftNavOnConsole then nil else UDim2.fromOffset(0, -v47.top),
				Size = if not FFlagExtendScrollingFramesBySafeInsets and not FFlagEnableLeftNavOnConsole then nil else UDim2.new(1, 0, 1, v47.top + v47.bottom),
				VerticalScrollBarInset = Enum.ScrollBarInset.None
			},
			animationConfig = u26.animationConfig,
			overrideAutomaticCanvasSize = not FFlagEnableLeftNavOnConsole,
			isSequentiallySelectable = not not v20 or nil
		}),
		Fullscreen = React.createElement("CanvasGroup", {
			BorderSizePixel = 0,
			ZIndex = 4,
			Size = UDim2.fromScale(1, 1),
			GroupTransparency = v41
		}, {
			FullscreenContent = if not v40 then nil else renderFullscreenContent()
		})
	})
end

return DetailsPageTenfootTemplate
