local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local view = Foundation.View

local useMemo = React.useMemo
local useSignalState = SignalsReact.useSignalState
local useTokens = Foundation.Hooks.useTokens
local useFormFactor = MomentsCommon.Hooks.useFormFactor

local formFactor = MomentsCommon.Enums.FormFactor
local eventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local fFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local v5 = {
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

local function TextColorSwatchRow(p2)
	local controller = p2.controller
	local v6 = useTokens()
	local v7 = useFormFactor() == formFactor.Wide

	local v9 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p3)
			local activeSession = controller.getActiveSession(p3)
			local v9 = if activeSession ~= nil then activeSession.getDraft(p3) else nil
			local v10 = v9 and v9[1]

			if v10 == nil then
				return (Color3.new(0, 0, 0))
			end

			return v10.textOverlayStyle.fontColor
		end)
	end, { controller })))

	local function onSwatchActivated(p3, k)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v10 = draft and draft[1]

		if v10 == nil then
			return
		end

		activeSession.update({ Dash.joinDeep(v10, {
				textOverlayStyle = { fontColor = p3 }
			}) })

		if fFlagMomentsTextOverlayV2Redesign then
			fireAnalyticsEvent(eventNames.EditingFlowTextOverlayColorSelected, makeCreationEventFields.makeTextOverlayEventFields({
				buttonIndex = tostring(k),
				color = "#" .. p3:ToHex()
			}))
		end
	end

	local children = {}

	for k, v10 in v5 do
		local v11 = v9 == v10
		children["Swatch" .. k] = React.createElement(view, {
			LayoutOrder = k,
			tag = "radius-circle",
			Size = UDim2.fromOffset(32, 32),
			backgroundStyle = { Color3 = v10 },
			onActivated = function()
				onSwatchActivated(v10, k)
			end,
			stroke = {
				Color = v6.Color.System.Contrast.Color3,
				Thickness = 3,
				Transparency = v11 and 0 or 0.8
			}
		})
	end

	return React.createElement(Foundation.ScrollView, {
		LayoutOrder = p2.LayoutOrder,
		Size = UDim2.new(1, 0, 0, Constants.TextOverlay.PickerRowHeight),
		scroll = {
			scrollBarVisibility = Foundation.Enums.Visibility.None,
			ScrollingDirection = Enum.ScrollingDirection.X,
			AutomaticCanvasSize = Enum.AutomaticSize.X
		}
	}, {
		Row = React.createElement(view, {
			tag = {
				["row align-y-center gap-medium size-0-full auto-x padding-x-large"] = true,
				["position-top-center anchor-top-center"] = v7
			}
		}, children)
	})
end

return TextColorSwatchRow
