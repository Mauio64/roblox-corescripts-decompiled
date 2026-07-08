local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Foundation = require(MomentsCreationFlowParent.Foundation)
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
local Button = Foundation.Button
local View = Foundation.View
local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)
local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)

return function(t1: {[any]: any}) -- line: 25
	-- upvalues: useDeviceInsets (copy), useTokens (copy), React (copy), CreationFlowContext (copy), useCallback (copy), View (copy), Button (copy), Foundation (copy), CreationFlowLocalization (copy)
	local v14 = useDeviceInsets()
	local v15 = useTokens()
	local v16 = React.useContext(CreationFlowContext)
	local v17 = useCallback(function() -- line: 30
		-- upvalues: t1 (copy)
		if t1.onTextOverlayDiscard then
			t1.onTextOverlayDiscard()
		end
	end, { t1.onTextOverlayDiscard })
	local v18 = useCallback(function() -- line: 36
		-- upvalues: t1 (copy)
		if t1.onTextOverlaySave then
			t1.onTextOverlaySave()
		end
	end, { t1.onTextOverlaySave })

	return React.createElement(View, {
		tag = "align-x-center auto-y align-y-bottom anchor-bottom-center col gap-large position-bottom-center size-full-0",
		LayoutOrder = t1.layoutOrder
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v15.Padding.Small),
			PaddingBottom = UDim.new(0, (math.max(v14.bottom, v15.Padding.Small))),
			PaddingLeft = UDim.new(0, (math.max(v14.left, v15.Padding.XLarge))),
			PaddingRight = UDim.new(0, (math.max(v14.right, v15.Padding.XLarge)))
		}),
		Nav = React.createElement(View, {
			LayoutOrder = 1,
			tag = "align-x-center align-y-center auto-y gap-small row size-full-0 flex-x-between"
		}, {
			BackButton = React.createElement(Button, {
				LayoutOrder = 1,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v16.getLocalization(CreationFlowLocalization.GeneralCtaBack),
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = v17,
				size = Foundation.Enums.InputSize.Medium
			}),
			DoneButton = React.createElement(Button, {
				LayoutOrder = 2,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v16.getLocalization(CreationFlowLocalization.GeneralCtaDone),
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = v18,
				size = Foundation.Enums.InputSize.Medium
			})
		})
	})
end
