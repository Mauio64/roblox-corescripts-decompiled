local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Foundation = require(MomentsCreationFlowParent.Foundation)
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local View = Foundation.View
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)
local Constants = require(MomentsCreationFlow.Constants)
local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: useDeviceInsets (copy), useTokens (copy), React (copy), CreationFlowContext (copy), View (copy), Constants (copy), Button (copy), Foundation (copy), InputSize (copy), CreationFlowLocalization (copy), ButtonVariant (copy)
	local v16 = useDeviceInsets()
	local v17 = useTokens()
	local v18 = React.useContext(CreationFlowContext)

	return React.createElement(View, {
		tag = "align-x-center auto-y size-full-0",
		LayoutOrder = t1.layoutOrder
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v17.Padding.Large),
			PaddingBottom = UDim.new(0, (math.max(v16.bottom, v17.Padding.Large))),
			PaddingLeft = UDim.new(0, (math.max(v16.left, v17.Padding.XLarge))),
			PaddingRight = UDim.new(0, (math.max(v16.right, v17.Padding.XLarge)))
		}),
		SizeConstraint = React.createElement(View, {
			tag = "align-x-center auto-y gap-small row size-full-0",
			sizeConstraint = {
				MaxSize = Constants.BottomBarSizeConstraint
			}
		}, {
			ContinueButton = React.createElement(Button, {
				LayoutOrder = 1,
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				onActivated = t1.onContinueCallback,
				size = InputSize.Medium,
				text = v18.getLocalization(CreationFlowLocalization.PublishingCtaContinue),
				variant = ButtonVariant.Emphasis,
				width = UDim.new(0.5, 0)
			}),
			ReturnToGalleryButton = if not t1.onReturnToGalleryCallback then nil else React.createElement(Button, {
				LayoutOrder = 2,
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				text = v18.getLocalization(CreationFlowLocalization.PublishingCtaReturn),
				variant = ButtonVariant.Standard,
				width = UDim.new(0.5, 0),
				onActivated = t1.onReturnToGalleryCallback,
				size = InputSize.Medium
			})
		})
	})
end
