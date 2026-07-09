local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local LoadableImage = require(Parent.UIBlox).App.Loading.LoadableImage
local TextSize = require(Parent.TextSize)
local SignalsReact = require(Parent.SignalsReact)

require(Parent.SduiCompat)

local View = Foundation.View
local FoundationText = Foundation.Text
local Button = Foundation.Button
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local CursorType = Foundation.Enums.CursorType
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local FFlagFixSduiCardFocusNavScroll = require(Parent.SharedFlags).FFlagFixSduiCardFocusNavScroll

local function v17() -- line: 33
end
local function SduiCard(t1: {[any]: any}) -- line: 60
	-- upvalues: useTokens (copy), FFlagFixSduiCardFocusNavScroll (copy), useCursor (copy), CursorType (copy), SignalsReact (copy), TextSize (copy), React (copy), View (copy), v17 (copy), StateLayerAffordance (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy), LoadableImage (copy)
	local v20 = useTokens()
	local v21 = if not FFlagFixSduiCardFocusNavScroll then nil else useCursor(CursorType.RoundedRect)
	local Size_2500 = v20.Size.Size_2500
	local v23 = SignalsReact.useSignalState(function(p1) -- line: 65
		-- upvalues: TextSize (copy)
		return TextSize.getTextSizeStore(p1).getTextSizeOffset(p1)
	end)
	local v24 = nil

	if t1.descriptionMaxLines and t1.descriptionMaxLines > 0 then
		local BodyMedium = v20.Typography.BodyMedium
		local v26 = BodyMedium.FontSize + v23

		v24 = math.ceil(t1.descriptionMaxLines * v26 * BodyMedium.LineHeight)
	end

	local v27, v28 = React.useState(0)
	local v29 = React.useCallback(function(p2) -- line: 77
		-- upvalues: v28 (copy)
		v28(p2.AbsoluteSize.Y)
	end, {})
	local v30 = if not FFlagFixSduiCardFocusNavScroll then nil else React.useMemo(function() -- line: 82
		-- upvalues: v21 (copy), t1 (copy)
		return {
			Selectable = true,
			SelectionImageObject = v21,
			SelectionOrder = t1.selectionOrder
		}
	end, {
		v21,
		t1.selectionOrder
	})

	return React.createElement(View, {
		tag = "size-full-0 row auto-y stroke-default",
		backgroundStyle = t1.backgroundStyle or v20.Color.Surface.Surface_100,
		cornerRadius = t1.cornerRadius or UDim.new(0, v20.Radius.Medium),
		selection = v30,
		onStateChanged = if not FFlagFixSduiCardFocusNavScroll then nil else v17,
		stateLayer = if not FFlagFixSduiCardFocusNavScroll then nil else {
			affordance = StateLayerAffordance.None
		},
		AnchorPoint = t1.anchorPoint,
		LayoutOrder = t1.layoutOrder,
		Position = t1.position,
		Size = t1.size,
		ZIndex = t1.zIndex,
		testId = t1.testId
	}, {
		ContentSection = React.createElement(View, {
			tag = "flex-between size-full-0 auto-y col gap-xsmall padding-top-large padding-bottom-large padding-left-large padding-right-small",
			LayoutOrder = 1,
			Size = UDim2.new(UDim.new(1, -Size_2500), t1.size and t1.size.Height or UDim.new(0, 0)),
			onAbsoluteSizeChanged = v29
		}, {
			TopContent = React.createElement(View, {
				tag = "col size-full-0 auto-y gap-xsmall",
				LayoutOrder = 1
			}, {
				Title = React.createElement(FoundationText, {
					tag = "size-full-0 auto-y text-align-x-left text-wrap text-label-large content-emphasis",
					LayoutOrder = 1,
					Text = t1.titleText
				}),
				Subtitle = t1.descriptionText and React.createElement(FoundationText, {
					LayoutOrder = 2,
					Text = t1.descriptionText,
					fontStyle = v20.Typography.BodyMedium,
					sizeConstraint = if not v24 then nil else {
						MaxSize = Vector2.new(1e999, v24)
					},
					tag = {
						["size-full-0 auto-y text-align-x-left text-wrap"] = true,
						["text-truncate-split"] = not not v24
					}
				}) or nil
			}),
			CTAContainer = if not t1.ctaText or not t1.ctaOnActivated then nil else React.createElement(View, {
				tag = "auto-xy padding-top-medium",
				LayoutOrder = 2
			}, {
				CTAButton = React.createElement(Button, {
					text = t1.ctaText,
					onActivated = t1.ctaOnActivated,
					variant = t1.ctaVariant or ButtonVariant.SoftEmphasis,
					size = t1.ctaSize or InputSize.Small
				})
			})
		}),
		ImageSection = if not t1.image then nil else React.createElement(LoadableImage, {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			showFailedStateWhenLoadingFailed = false,
			useShimmerAnimationWhileLoading = true,
			Image = t1.image,
			Size = UDim2.new(0, Size_2500, 0, v27),
			ImageColor3 = t1.imageStyle and t1.imageStyle.Color3 or v20.Color.Content.Emphasis.Color3,
			ImageTransparency = t1.imageStyle and t1.imageStyle.Transparency or 0,
			ScaleType = Enum.ScaleType.Crop,
			cornerRadius = t1.cornerRadius or UDim.new(0, v20.Radius.Medium)
		})
	})
end

return React.memo(SduiCard)
