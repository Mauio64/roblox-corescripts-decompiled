local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local LoadableImage = UIBlox.App.Loading.LoadableImage
local TextSize = require(parent.TextSize)
local SignalsReact = require(parent.SignalsReact)
require(parent.SduiCompat)

local View = Foundation.View
local Text = Foundation.Text
local Button = Foundation.Button
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local CursorType = Foundation.Enums.CursorType
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local SharedFlags = require(parent.SharedFlags)
local FFlagFixSduiCardFocusNavScroll = SharedFlags.FFlagFixSduiCardFocusNavScroll
local FFlagLuaAppConfigureSduiCardImageScaleType = SharedFlags.FFlagLuaAppConfigureSduiCardImageScaleType
local FFlagSduiCardBackgroundClickable = SharedFlags.FFlagSduiCardBackgroundClickable

local function fn() end

local function SduiCard(props)
	local v = useTokens()
	local selectionImageObject

	if FFlagFixSduiCardFocusNavScroll then
		selectionImageObject = useCursor(CursorType.RoundedRect)
	else
		selectionImageObject = nil
	end

	local size_2500 = v.Size.Size_2500

	local v2 = SignalsReact.useSignalState(function(p)
		return TextSize.getTextSizeStore(p).getTextSizeOffset(p)
	end)
	local v3

	if props.descriptionMaxLines and props.descriptionMaxLines > 0 then
		local bodyMedium = v.Typography.BodyMedium
		local v4 = bodyMedium.FontSize + v2
		v3 = math.ceil(props.descriptionMaxLines * v4 * bodyMedium.LineHeight)
	end

	local state, setState = React.useState(0)
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize.Y)
	end, {})
	local selection

	if FFlagFixSduiCardFocusNavScroll then
		selection = React.useMemo(function()
			return {
				Selectable = true,
				SelectionImageObject = selectionImageObject,
				SelectionOrder = props.selectionOrder
			}
		end, { selectionImageObject, props.selectionOrder })
	end

	local createElement = React.createElement
	local v4 = {
		tag = "size-full-0 row auto-y stroke-default",
		backgroundStyle = props.backgroundStyle or v.Color.Surface.Surface_100,
		cornerRadius = props.cornerRadius or UDim.new(0, v.Radius.Medium),
		selection = selection,
		onStateChanged = 0,
		stateLayer = 0,
		onActivated = 0,
		AnchorPoint = 0,
		LayoutOrder = 0,
		Position = 0,
		Size = 0,
		ZIndex = 0,
		testId = 0
	}
	local onStateChanged

	if FFlagFixSduiCardFocusNavScroll then
		onStateChanged = fn
	end

	v4.onStateChanged = onStateChanged
	local stateLayer

	if FFlagFixSduiCardFocusNavScroll then
		stateLayer = (not FFlagSduiCardBackgroundClickable or props.backgroundOnActivated == nil)
			and { affordance = StateLayerAffordance.None }
			or nil
	end

	v4.stateLayer = stateLayer
	local onActivated

	if FFlagSduiCardBackgroundClickable then
		onActivated = props.backgroundOnActivated
	end

	v4.onActivated = onActivated
	v4.AnchorPoint = props.anchorPoint
	v4.LayoutOrder = props.layoutOrder
	v4.Position = props.position
	v4.Size = props.size
	v4.ZIndex = props.zIndex
	v4.testId = props.testId

	local createElement2 = React.createElement
	local v5 = {
		tag = "flex-between size-full-0 auto-y col gap-xsmall padding-top-large padding-bottom-large padding-left-large padding-right-small",
		Size = UDim2.new(UDim.new(1, -size_2500), props.size and props.size.Height or UDim.new(0, 0)),
		LayoutOrder = 1,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged
	}

	local createElement3 = React.createElement

	local v6 = {
		Title = React.createElement(Text, {
			Text = props.titleText,
			tag = "size-full-0 auto-y text-align-x-left text-wrap text-label-large content-emphasis",
			LayoutOrder = 1
		}),
		Subtitle = 0
	}
	local subtitle

	if props.descriptionText then
		subtitle = React.createElement(Text, {
			Text = props.descriptionText,
			fontStyle = v.Typography.BodyMedium,
			sizeConstraint = v3 and { MaxSize = Vector2.new(1e999, v3) } or nil,
			tag = {
				["size-full-0 auto-y text-align-x-left text-wrap"] = true,
				["text-truncate-split"] = v3 and true or false
			},
			LayoutOrder = 2
		}) or nil
	end

	v6.Subtitle = subtitle
	local v7 = {
		TopContent = createElement3(View, {
			tag = "col size-full-0 auto-y gap-xsmall",
			LayoutOrder = 1
		}, v6),
		CTAContainer = 0
	}
	local ctaContainer

	if props.ctaText and props.ctaOnActivated then
		local createElement4 = React.createElement

		local createElement5 = React.createElement
		local v8 = {
			text = props.ctaText,
			onActivated = props.ctaOnActivated,
			variant = props.ctaVariant or ButtonVariant.SoftEmphasis,
			size = props.ctaSize or InputSize.Small,
			testId = 0
		}
		local testId

		if props.testId then
			testId = `{props.testId}--cta`
		end

		v8.testId = testId
		ctaContainer = createElement4(View, { tag = "auto-xy padding-top-medium", LayoutOrder = 2 }, {
			CTAButton = createElement5(Button, v8)
		})
	end

	v7.CTAContainer = ctaContainer
	local v8 = { ContentSection = createElement2(View, v5, v7), ImageSection = 0 }
	local imageSection

	if props.image then
		imageSection = React.createElement(LoadableImage, {
			Image = props.image,
			Size = UDim2.new(0, size_2500, 0, state),
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			ImageColor3 = props.imageStyle and props.imageStyle.Color3 or v.Color.Content.Emphasis.Color3,
			ImageTransparency = props.imageStyle and props.imageStyle.Transparency or 0,
			ScaleType = FFlagLuaAppConfigureSduiCardImageScaleType and props.imageScaleType or Enum.ScaleType.Crop,
			cornerRadius = props.cornerRadius or UDim.new(0, v.Radius.Medium),
			showFailedStateWhenLoadingFailed = false,
			useShimmerAnimationWhileLoading = true
		})
	end

	v8.ImageSection = imageSection
	return createElement(View, v4, v8)
end

return React.memo(SduiCard)
