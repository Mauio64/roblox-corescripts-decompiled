local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View

local useMemo = React.useMemo
local useSignalState = SignalsReact.useSignalState
local useTokens = Foundation.Hooks.useTokens
local useFormFactor = MomentsCommon.Hooks.useFormFactor

local FormFactor = MomentsCommon.Enums.FormFactor
local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local FFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign

local Constants = require(MomentsCreation.Constants)
require(MomentsCreation.Types.CreationFlowTypes)
require(parent.MomentsTypes)

local v = {
	Color3.fromHex("000000"),
	Color3.fromHex("E75750"),
	Color3.fromHex("F57630"),
	Color3.fromHex("DBA61F"),
	Color3.fromHex("0C9B5A"),
	Color3.fromHex("16A9C7"),
	Color3.fromHex("528BFF"),
	Color3.fromHex("A766F5"),
	Color3.fromHex("D540F5"),
	Color3.fromHex("E74E90")
}

local function TextColorSwatchRow(p)
	local controller = p.controller
	local v2 = useTokens()
	local positiontopcenteranchortopcenter = useFormFactor() == FormFactor.Wide

	local v3 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p2)
			local activeSession = controller.getActiveSession(p2)
			local v3

			if activeSession ~= nil then
				v3 = activeSession.getDraft(p2)
			end

			local v4 = v3 and v3[1]

			if v4 == nil then
				return (Color3.new(0, 0, 0))
			end

			return v4.textOverlayStyle.fontColor
		end)
	end, { controller })))

	local function onSwatchActivated(fontColor: Color3, k: number)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v4 = draft and draft[1]

		if v4 == nil then
			return
		end

		activeSession.update({ Dash.joinDeep(v4, {
				textOverlayStyle = { fontColor = fontColor }
			}) })

		if FFlagMomentsTextOverlayV2Redesign then
			fireAnalyticsEvent(
				EventNames.EditingFlowTextOverlayColorSelected,
				makeCreationEventFields.makeTextOverlayEventFields({
					buttonIndex = tostring(k),
					color = "#" .. fontColor:ToHex()
				})
			)
		end
	end

	local children = {}

	for k, color in v do
		local v4 = v3 == color
		children["Swatch" .. k] = React.createElement(View, {
			LayoutOrder = k,
			tag = "radius-circle",
			Size = UDim2.fromOffset(32, 32),
			backgroundStyle = { Color3 = color },
			onActivated = function()
				onSwatchActivated(color, k)
			end,
			stroke = {
				Color = v2.Color.System.Contrast.Color3,
				Thickness = 3,
				Transparency = v4 and 0 or 0.8
			}
		})
	end

	return React.createElement(Foundation.ScrollView, {
		LayoutOrder = p.LayoutOrder,
		Size = UDim2.new(1, 0, 0, Constants.TextOverlay.PickerRowHeight),
		scroll = {
			scrollBarVisibility = Foundation.Enums.Visibility.None,
			ScrollingDirection = Enum.ScrollingDirection.X,
			AutomaticCanvasSize = Enum.AutomaticSize.X
		}
	}, {
		Row = React.createElement(View, {
			tag = {
				["row align-y-center gap-medium size-0-full auto-x padding-x-large"] = true,
				["position-top-center anchor-top-center"] = positiontopcenteranchortopcenter
			}
		}, children)
	})
end

return TextColorSwatchRow
