local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local loadableImage = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/UIBlox").App.Loading.LoadableImage
local TextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/TextSize")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCompat")

local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local cursorType = Foundation.Enums.CursorType
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags")
local fFlagFixSduiCardFocusNavScroll = SharedFlags.FFlagFixSduiCardFocusNavScroll
local fFlagLuaAppConfigureSduiCardImageScaleType = SharedFlags.FFlagLuaAppConfigureSduiCardImageScaleType
local fFlagSduiCardBackgroundClickable = SharedFlags.FFlagSduiCardBackgroundClickable

local function fn() end

local function SduiCard(props)
	local v5 = useTokens()
	local v6 = if fFlagFixSduiCardFocusNavScroll then useCursor(cursorType.RoundedRect) else nil
	local size_2500 = v5.Size.Size_2500

	local v7 = SignalsReact.useSignalState(function(p2)
		return TextSize.getTextSizeStore(p2).getTextSizeOffset(p2)
	end)
	local v8

	if props.descriptionMaxLines and props.descriptionMaxLines > 0 then
		local bodyMedium = v5.Typography.BodyMedium
		local v9 = bodyMedium.FontSize + v7
		v8 = math.ceil(props.descriptionMaxLines * v9 * bodyMedium.LineHeight)
	end

	local state, setState = React.useState(0)
	local v9 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize.Y)
	end, {})
	local v10

	if fFlagFixSduiCardFocusNavScroll then
		v10 = React.useMemo(function()
			return {
				Selectable = true,
				SelectionImageObject = v6,
				SelectionOrder = props.selectionOrder
			}
		end, { v6, props.selectionOrder })
	end

	local createElement = React.createElement
	local v12 = {
		tag = "size-full-0 row auto-y stroke-default",
		backgroundStyle = props.backgroundStyle or v5.Color.Surface.Surface_100,
		cornerRadius = props.cornerRadius or UDim.new(0, v5.Radius.Medium),
		selection = v10,
		onStateChanged = if fFlagFixSduiCardFocusNavScroll then fn else nil,
		stateLayer = 0,
		onActivated = 0,
		AnchorPoint = 0,
		LayoutOrder = 0,
		Position = 0,
		Size = 0,
		ZIndex = 0,
		testId = 0
	}

	local v14 = if fFlagFixSduiCardFocusNavScroll then (not fFlagSduiCardBackgroundClickable or props.backgroundOnActivated == nil) and {
		affordance = stateLayerAffordance.None
	} or nil else nil
	v12.stateLayer = v14

	local v15 = if fFlagSduiCardBackgroundClickable then props.backgroundOnActivated else nil
	v12.onActivated = v15
	v12.AnchorPoint = props.anchorPoint
	v12.LayoutOrder = props.layoutOrder
	v12.Position = props.position
	v12.Size = props.size
	v12.ZIndex = props.zIndex
	v12.testId = props.testId

	local createElement2 = React.createElement
	local v18 = {
		tag = "flex-between size-full-0 auto-y col gap-xsmall padding-top-large padding-bottom-large padding-left-large padding-right-small",
		Size = UDim2.new(UDim.new(1, -size_2500), props.size and props.size.Height or UDim.new(0, 0)),
		LayoutOrder = 1,
		onAbsoluteSizeChanged = v9
	}

	local createElement3 = React.createElement

	local v22 = {
		Title = React.createElement(text, {
			Text = props.titleText,
			tag = "size-full-0 auto-y text-align-x-left text-wrap text-label-large content-emphasis",
			LayoutOrder = 1
		}),
		Subtitle = 0
	}

	local v23 = if props.descriptionText then React.createElement(text, {
		Text = props.descriptionText,
		fontStyle = v5.Typography.BodyMedium,
		sizeConstraint = v8 and { MaxSize = Vector2.new(1e999, v8) } or nil,
		tag = {
			["size-full-0 auto-y text-align-x-left text-wrap"] = true,
			["text-truncate-split"] = v8 and true or false
		},
		LayoutOrder = 2
	}) or nil else nil
	v22.Subtitle = v23
	local v19 = {
		TopContent = createElement3(
			view,
			{ tag = "col size-full-0 auto-y gap-xsmall", LayoutOrder = 1 },
			v22
		),
		CTAContainer = 0
	}
	local v24

	if props.ctaText and props.ctaOnActivated then
		local createElement4 = React.createElement

		local createElement5 = React.createElement
		local v29 = {
			text = props.ctaText,
			onActivated = props.ctaOnActivated,
			variant = props.ctaVariant or buttonVariant.SoftEmphasis,
			size = props.ctaSize or inputSize.Small,
			testId = 0
		}
		local v30 = if props.testId then `{props.testId}--cta` else nil
		v29.testId = v30
		v24 = createElement4(view, {
			tag = "auto-xy padding-top-medium",
			LayoutOrder = 2
		}, {
			CTAButton = createElement5(button, v29)
		})
	end

	v19.CTAContainer = v24
	local v16 = { ContentSection = createElement2(view, v18, v19), ImageSection = 0 }

	local v25 = if props.image then React.createElement(loadableImage, {
		Image = props.image,
		Size = UDim2.new(0, size_2500, 0, state),
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		ImageColor3 = props.imageStyle and props.imageStyle.Color3 or v5.Color.Content.Emphasis.Color3,
		ImageTransparency = props.imageStyle and props.imageStyle.Transparency or 0,
		ScaleType = fFlagLuaAppConfigureSduiCardImageScaleType and props.imageScaleType or Enum.ScaleType.Crop,
		cornerRadius = props.cornerRadius or UDim.new(0, v5.Radius.Medium),
		showFailedStateWhenLoadingFailed = false,
		useShimmerAnimationWhileLoading = true
	}) else nil
	v16.ImageSection = v25
	return createElement(view, v12, v16)
end

return React.memo(SduiCard)
