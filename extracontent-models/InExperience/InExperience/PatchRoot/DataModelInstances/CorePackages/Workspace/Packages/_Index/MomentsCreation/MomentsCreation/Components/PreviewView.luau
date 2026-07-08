local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local View = Foundation.View
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local Constants = require(MomentsCreation.Constants)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

return function(t1: {[any]: any}) -- line: 28
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useCreationFlowStrings (copy), React (copy), View (copy), Constants (copy), Button (copy), Foundation (copy), InputSize (copy), ButtonVariant (copy)
	local v15 = useDeviceInsets()
	local v16 = useTokens()
	local v17 = useCreationFlowStrings()
	local PublishingCtaReturn = v17.PublishingCtaReturn

	return React.createElement(View, {
		tag = "align-x-center size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		padding = {
			top = UDim.new(0, v16.Padding.Large),
			bottom = UDim.new(0, (math.max(v15.bottom, v16.Padding.Large))),
			left = UDim.new(0, (math.max(v15.left, v16.Padding.XLarge))),
			right = UDim.new(0, (math.max(v15.right, v16.Padding.XLarge)))
		}
	}, {
		SizeConstraint = React.createElement(View, {
			tag = "row align-x-center gap-small size-full-0 auto-y",
			sizeConstraint = {
				MaxSize = Constants.BottomBarSizeConstraint
			}
		}, {
			ContinueButton = React.createElement(Button, {
				LayoutOrder = 1,
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				onActivated = t1.onContinueCallback,
				size = InputSize.Medium,
				text = v17.PublishingCtaContinue,
				variant = ButtonVariant.Emphasis,
				width = UDim.new(0.5, 0)
			}),
			ReturnToGalleryButton = if not t1.onReturnToGalleryCallback then nil else React.createElement(Button, {
				LayoutOrder = 2,
				fillBehavior = Foundation.Enums.FillBehavior.Fill,
				text = PublishingCtaReturn,
				variant = ButtonVariant.Standard,
				width = UDim.new(0.5, 0),
				onActivated = t1.onReturnToGalleryCallback,
				size = InputSize.Medium
			})
		})
	})
end
