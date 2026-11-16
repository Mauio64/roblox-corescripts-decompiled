local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local View = Foundation.View

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)

local Constants = require(MomentsCreationFlow.Constants)
local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)

return function(props)
	local v = useDeviceInsets()
	local v2 = useTokens()
	local v3 = React.useContext(CreationFlowContext)

	local createElement = React.createElement
	local v4 = { LayoutOrder = props.layoutOrder, tag = "align-x-center auto-y size-full-0" }

	local v5 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v2.Padding.Large),
			PaddingBottom = UDim.new(0, (math.max(v.bottom, v2.Padding.Large))),
			PaddingLeft = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
			PaddingRight = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
		}),
		SizeConstraint = 0
	}

	local createElement2 = React.createElement
	local v6 = {
		sizeConstraint = { MaxSize = Constants.BottomBarSizeConstraint },
		tag = "align-x-center auto-y gap-small row size-full-0"
	}

	local v7 = {
		ContinueButton = React.createElement(Button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 1,
			onActivated = props.onContinueCallback,
			size = InputSize.Medium,
			text = v3.getLocalization(CreationFlowLocalization.PublishingCtaContinue),
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
			text = v3.getLocalization(CreationFlowLocalization.PublishingCtaReturn),
			variant = ButtonVariant.Standard,
			width = UDim.new(0.5, 0),
			onActivated = props.onReturnToGalleryCallback,
			size = InputSize.Medium
		})
	end

	v7.ReturnToGalleryButton = returnToGalleryButton
	v5.SizeConstraint = createElement2(View, v6, v7)
	return createElement(View, v4, v5)
end
