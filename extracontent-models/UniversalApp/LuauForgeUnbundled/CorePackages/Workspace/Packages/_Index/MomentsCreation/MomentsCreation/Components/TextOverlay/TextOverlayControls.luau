local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local button = Foundation.Button
local knob = Foundation.Knob
local slider = Foundation.Slider
local view = Foundation.View

local useCallback = React.useCallback
local useMemo = React.useMemo
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")
local fFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign
local FFlagMomentsTextOverlayTopNav = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayTopNav")

local function TextOverlayControls(p2)
	local controller = p2.controller
	local v5 = useDeviceInsets()
	local v6 = useTokens()
	local v7 = useCreationFlowStrings()

	local v8 = fFlagMomentsTextOverlayV2Redesign
	local v10 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p3)
			if v8 then
				return Constants.TextOverlay.DefaultFontSize
			end

			local activeSession = controller.getActiveSession(p3)
			local v10 = if activeSession ~= nil then activeSession.getDraft(p3) else nil
			local v11 = v10 and v10[1]

			if v11 == nil then
				return Constants.TextOverlay.DefaultFontSize
			end

			return v11.textOverlayStyle.fontSize
		end)
	end, { controller, v8 })))

	local v11 = useCallback(function(p3)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v12 = draft and draft[1]

		if v12 == nil then
			return
		end

		activeSession.update({ Dash.joinDeep(v12, {
				textOverlayStyle = { fontSize = p3 }
			}) })
	end, { controller })

	local v12 = useCallback(function()
		controller.discardActiveTool()
	end, { controller })

	local v13 = useCallback(function()
		controller.commitActiveTool()
	end, { controller })

	if FFlagMomentsTextOverlayTopNav then
		return nil
	end

	local createElement = React.createElement
	local v15 = {
		LayoutOrder = p2.layoutOrder,
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v6.Padding.Small),
			bottom = UDim.new(0, (math.max(v5.bottom, v6.Padding.Small))),
			left = UDim.new(0, (math.max(v5.left, v6.Padding.XLarge))),
			right = UDim.new(0, (math.max(v5.right, v6.Padding.XLarge)))
		}
	}

	local v17 = if not v8 then React.createElement(slider, {
		knob = React.createElement(knob, { size = Foundation.Enums.InputSize.Large }),
		knobVisibility = Foundation.Enums.Visibility.Always,
		LayoutOrder = 1,
		onValueChanged = v11,
		size = Foundation.Enums.InputSize.XSmall,
		range = NumberRange.new(Constants.TextOverlay.MinFontSize, Constants.TextOverlay.MaxFontSize),
		value = math.clamp(v10, Constants.TextOverlay.MinFontSize, Constants.TextOverlay.MaxFontSize),
		variant = Foundation.Enums.SliderVariant.Standard
	}) else nil
	return createElement(view, v15, {
		FontSizeSlider = v17,
		Nav = React.createElement(
			view,
			{
				LayoutOrder = 2,
				tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
			},
			{
				BackButton = React.createElement(button, {
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 1,
					text = v7.GeneralCtaBack,
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = v12,
					size = Foundation.Enums.InputSize.Medium
				}),
				DoneButton = React.createElement(button, {
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 2,
					text = v7.GeneralCtaDone,
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = v13,
					size = Foundation.Enums.InputSize.Medium
				})
			}
		)
	})
end

return TextOverlayControls
