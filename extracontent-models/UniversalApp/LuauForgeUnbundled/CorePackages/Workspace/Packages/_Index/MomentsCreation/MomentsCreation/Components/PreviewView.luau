local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local view = Foundation.View

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")

return function(props)
	local v5 = useDeviceInsets()
	local v6 = useTokens()
	local v7 = useCreationFlowStrings()

	local publishingCtaReturn = v7.PublishingCtaReturn

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = props.layoutOrder,
		tag = "align-x-center size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v6.Padding.Large),
			bottom = UDim.new(0, (math.max(v5.bottom, v6.Padding.Large))),
			left = UDim.new(0, (math.max(v5.left, v6.Padding.XLarge))),
			right = UDim.new(0, (math.max(v5.right, v6.Padding.XLarge)))
		}
	}

	local createElement2 = React.createElement
	local v12 = {
		sizeConstraint = { MaxSize = Constants.BottomBarSizeConstraint },
		tag = "row align-x-center gap-small size-full-0 auto-y"
	}

	local v13 = {
		ContinueButton = React.createElement(button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			LayoutOrder = 1,
			onActivated = props.onContinueCallback,
			size = inputSize.Medium,
			text = v7.PublishingCtaContinue,
			variant = buttonVariant.Emphasis,
			width = UDim.new(0.5, 0)
		}),
		ReturnToGalleryButton = 0
	}

	local v14 = if props.onReturnToGalleryCallback then React.createElement(button, {
		fillBehavior = Foundation.Enums.FillBehavior.Fill,
		LayoutOrder = 2,
		text = publishingCtaReturn,
		variant = buttonVariant.Standard,
		width = UDim.new(0.5, 0),
		onActivated = props.onReturnToGalleryCallback,
		size = inputSize.Medium
	}) else nil
	v13.ReturnToGalleryButton = v14
	return createElement(view, v9, { SizeConstraint = createElement2(view, v12, v13) })
end
