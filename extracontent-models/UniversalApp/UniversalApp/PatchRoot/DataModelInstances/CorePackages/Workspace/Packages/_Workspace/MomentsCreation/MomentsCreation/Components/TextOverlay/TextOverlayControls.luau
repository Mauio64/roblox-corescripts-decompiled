local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Dash = require(MomentsCreationParent.Dash)
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Signals = require(MomentsCreationParent.Signals)
local SignalsReact = require(MomentsCreationParent.SignalsReact)
local Button = Foundation.Button
local Knob = Foundation.Knob
local Slider = Foundation.Slider
local View = Foundation.View
local useCallback = React.useCallback
local useMemo = React.useMemo
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState
local Constants = require(MomentsCreation.Constants)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

require(MomentsCreation.Types.CreationFlowTypes)
require(MomentsCreationParent.MomentsTypes)

local function TextOverlayControls(t1: {[any]: any}) -- line: 45
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useCreationFlowStrings (copy), useMemo (copy), Signals (copy), Constants (copy), useSignalState (copy), useCallback (copy), Dash (copy), React (copy), View (copy), Slider (copy), Knob (copy), Foundation (copy), Button (copy)
	local controller = t1.controller
	local v23 = useDeviceInsets()
	local v24 = useTokens()
	local v25 = useCreationFlowStrings()
	local v26 = useMemo(function() -- line: 53
		-- upvalues: Signals (copy), controller (copy), Constants (copy)
		return Signals.createComputed(function(p1) -- line: 54
			-- upvalues: controller (copy), Constants (copy)
			local v36 = controller.getActiveSession(p1)
			local v37 = if v36 == nil then nil else v36.getDraft(p1)
			local v38 = v37 and v37[1]

			if v38 ~= nil then
				return v38.textOverlayStyle.fontSize
			end

			return Constants.TextOverlay.DefaultFontSize
		end)
	end, { controller })
	local v27 = useSignalState(v26)
	local v28 = useCallback(function(n1: number) -- line: 63
		-- upvalues: controller (copy), Dash (copy)
		local v32 = controller.getActiveSession(false)

		if v32 == nil then
			return
		end

		local v33 = v32.getDraft(false)
		local v34 = v33 and v33[1]

		if v34 == nil then
			return
		end

		v32.update({ Dash.joinDeep(v34, {
			textOverlayStyle = {
				fontSize = n1
			}
		}) })
	end, { controller })
	local v29 = useCallback(function() -- line: 76
		-- upvalues: controller (copy)
		controller.discardActiveTool()
	end, { controller })
	local v30 = useCallback(function() -- line: 80
		-- upvalues: controller (copy)
		controller.commitActiveTool()
	end, { controller })

	return React.createElement(View, {
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		padding = {
			top = UDim.new(0, v24.Padding.Small),
			bottom = UDim.new(0, (math.max(v23.bottom, v24.Padding.Small))),
			left = UDim.new(0, (math.max(v23.left, v24.Padding.XLarge))),
			right = UDim.new(0, (math.max(v23.right, v24.Padding.XLarge)))
		}
	}, {
		FontSizeSlider = React.createElement(Slider, {
			LayoutOrder = 1,
			knob = React.createElement(Knob, {
				size = Foundation.Enums.InputSize.Large
			}),
			knobVisibility = Foundation.Enums.Visibility.Always,
			onValueChanged = v28,
			size = Foundation.Enums.InputSize.XSmall,
			range = NumberRange.new(Constants.TextOverlay.MinFontSize, Constants.TextOverlay.MaxFontSize),
			value = math.clamp(v27, Constants.TextOverlay.MinFontSize, Constants.TextOverlay.MaxFontSize),
			variant = Foundation.Enums.SliderVariant.Standard
		}),
		Nav = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
		}, {
			BackButton = React.createElement(Button, {
				LayoutOrder = 1,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v25.GeneralCtaBack,
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = v29,
				size = Foundation.Enums.InputSize.Medium
			}),
			DoneButton = React.createElement(Button, {
				LayoutOrder = 2,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v25.GeneralCtaDone,
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = v30,
				size = Foundation.Enums.InputSize.Medium
			})
		})
	})
end

return TextOverlayControls
