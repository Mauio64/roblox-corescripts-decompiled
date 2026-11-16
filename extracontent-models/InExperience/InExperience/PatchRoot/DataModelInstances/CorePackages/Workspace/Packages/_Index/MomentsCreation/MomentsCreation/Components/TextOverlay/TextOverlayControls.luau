local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

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
require(parent.MomentsTypes)
local FFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign
local FFlagMomentsTextOverlayTopNav = require(MomentsCreation.Flags.FFlagMomentsTextOverlayTopNav)

local function TextOverlayControls(p)
	local controller = p.controller
	local v = useDeviceInsets()
	local v2 = useTokens()
	local v3 = useCreationFlowStrings()

	local v4 = FFlagMomentsTextOverlayV2Redesign
	local v5 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p2)
			if v4 then
				return Constants.TextOverlay.DefaultFontSize
			end

			local activeSession = controller.getActiveSession(p2)
			local v5

			if activeSession ~= nil then
				v5 = activeSession.getDraft(p2)
			end

			local v6 = v5 and v5[1]

			if v6 == nil then
				return Constants.TextOverlay.DefaultFontSize
			end

			return v6.textOverlayStyle.fontSize
		end)
	end, { controller, v4 })))

	local onValueChanged = useCallback(function(fontSize: number)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v6 = draft and draft[1]

		if v6 == nil then
			return
		end

		activeSession.update({ Dash.joinDeep(v6, {
				textOverlayStyle = { fontSize = fontSize }
			}) })
	end, { controller })

	local onActivated = useCallback(function()
		controller.discardActiveTool()
	end, { controller })

	local onActivated2 = useCallback(function()
		controller.commitActiveTool()
	end, { controller })

	if FFlagMomentsTextOverlayTopNav then
		return nil
	end

	local createElement = React.createElement
	local v6 = {
		LayoutOrder = p.layoutOrder,
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v2.Padding.Small),
			bottom = UDim.new(0, (math.max(v.bottom, v2.Padding.Small))),
			left = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
			right = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
		}
	}
	local fontSizeSlider

	if not v4 then
		fontSizeSlider = React.createElement(Slider, {
			knob = React.createElement(Knob, { size = Foundation.Enums.InputSize.Large }),
			knobVisibility = Foundation.Enums.Visibility.Always,
			LayoutOrder = 1,
			onValueChanged = onValueChanged,
			size = Foundation.Enums.InputSize.XSmall,
			range = NumberRange.new(Constants.TextOverlay.MinFontSize, Constants.TextOverlay.MaxFontSize),
			value = math.clamp(v5, Constants.TextOverlay.MinFontSize, Constants.TextOverlay.MaxFontSize),
			variant = Foundation.Enums.SliderVariant.Standard
		})
	end

	return createElement(View, v6, {
		FontSizeSlider = fontSizeSlider,
		Nav = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
			},
			{
				BackButton = React.createElement(Button, {
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 1,
					text = v3.GeneralCtaBack,
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = onActivated,
					size = Foundation.Enums.InputSize.Medium
				}),
				DoneButton = React.createElement(Button, {
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 2,
					text = v3.GeneralCtaDone,
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = onActivated2,
					size = Foundation.Enums.InputSize.Medium
				})
			}
		)
	})
end

return TextOverlayControls
