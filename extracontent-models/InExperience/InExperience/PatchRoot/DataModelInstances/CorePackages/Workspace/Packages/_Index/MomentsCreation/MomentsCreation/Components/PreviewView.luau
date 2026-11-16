local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local View = Foundation.View

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local Constants = require(MomentsCreation.Constants)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

return function(props)
	local v = useDeviceInsets()
	local v2 = useTokens()
	local v3 = useCreationFlowStrings()

	local publishingCtaReturn = v3.PublishingCtaReturn

	local createElement = React.createElement
	local v4 = {
		LayoutOrder = props.layoutOrder,
		tag = "align-x-center size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v2.Padding.Large),
			bottom = UDim.new(0, (math.max(v.bottom, v2.Padding.Large))),
			left = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
			right = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
		}
	}

	local createElement2 = React.createElement
	local v5 = {
		sizeConstraint = { MaxSize = Constants.BottomBarSizeConstraint },
		tag = "row align-x-center gap-small size-full-0 auto-y"
	}

	local v6 = {
		ContinueButton = React.createElement(Button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 1,
			onActivated = props.onContinueCallback,
			size = InputSize.Medium,
			text = v3.PublishingCtaContinue,
			variant = ButtonVariant.Emphasis,
			width = UDim.new(0.5, 0)
		}),
		ReturnToGalleryButton = 0
	}
	local returnToGalleryButton

	if props.onReturnToGalleryCallback then
		returnToGalleryButton = React.createElement(Button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 2,
			text = publishingCtaReturn,
			variant = ButtonVariant.Standard,
			width = UDim.new(0.5, 0),
			onActivated = props.onReturnToGalleryCallback,
			size = InputSize.Medium
		})
	end

	v6.ReturnToGalleryButton = returnToGalleryButton
	return createElement(View, v4, { SizeConstraint = createElement2(View, v5, v6) })
end
