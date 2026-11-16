local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Button = Foundation.Button
local View = Foundation.View

local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)

local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)

return function(props)
	local v = useDeviceInsets()
	local v2 = useTokens()
	local v3 = React.useContext(CreationFlowContext)

	local onActivated = useCallback(function()
		if props.onTextOverlayDiscard then
			props.onTextOverlayDiscard()
		end
	end, { props.onTextOverlayDiscard })

	local onActivated2 = useCallback(function()
		if props.onTextOverlaySave then
			props.onTextOverlaySave()
		end
	end, { props.onTextOverlaySave })

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "align-x-center auto-y align-y-bottom anchor-bottom-center col gap-large position-bottom-center size-full-0"
		},
		{
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v2.Padding.Small),
				PaddingBottom = UDim.new(0, (math.max(v.bottom, v2.Padding.Small))),
				PaddingLeft = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
				PaddingRight = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
			}),
			Nav = React.createElement(
				View,
				{
					LayoutOrder = 1,
					tag = "align-x-center align-y-center auto-y gap-small row size-full-0 flex-x-between"
				},
				{
					BackButton = React.createElement(Button, {
						fillBehavior = Foundation.Enums.FillBehavior.Fit,
						LayoutOrder = 1,
						text = v3.getLocalization(CreationFlowLocalization.GeneralCtaBack),
						variant = Foundation.Enums.ButtonVariant.Text,
						onActivated = onActivated,
						size = Foundation.Enums.InputSize.Medium
					}),
					DoneButton = React.createElement(Button, {
						fillBehavior = Foundation.Enums.FillBehavior.Fit,
						LayoutOrder = 2,
						text = v3.getLocalization(CreationFlowLocalization.GeneralCtaDone),
						variant = Foundation.Enums.ButtonVariant.Text,
						onActivated = onActivated2,
						size = Foundation.Enums.InputSize.Medium
					})
				}
			)
		}
	)
end
