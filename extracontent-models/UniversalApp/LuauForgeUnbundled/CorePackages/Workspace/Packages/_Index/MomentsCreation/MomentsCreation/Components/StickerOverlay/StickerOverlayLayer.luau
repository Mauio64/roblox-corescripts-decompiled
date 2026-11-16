local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local view = Foundation.View

local useCallback = React.useCallback
local useMemo = React.useMemo
local useSignalState = SignalsReact.useSignalState

local overlayDisplay = MomentsCommon.Components.OverlayDisplay
local stickerOverlay = MomentsCommon.Components.StickerOverlay

local CreationFlowState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local function StickerOverlayLayer(props)
	local controller = props.controller

	local v5 = useSignalState(controller.getStep)
	local v6 = useSignalState(props.ctx.getItemSize)
	local stickerOverlays = useSignalState(controller.getComposedEdits).stickerOverlays

	local v8 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p2)
			local activeSession = controller.getActiveSession(p2)

			if activeSession == nil then
				return nil
			end

			return (activeSession.getDraft(p2))
		end)
	end, { controller })))

	local v9 = v5 == CreationFlowState.StickerOverlay
	local v10 = v8 and v8[1]

	local v11 = useCallback(function()
		controller.beginTool("sticker")
	end, { controller })

	local v12 = useCallback(function(p2)
		controller.updateCommittedEdit("sticker", p2)
	end, { controller })

	if v9 then
		local createElement = React.createElement
		local v14 = {
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = "size-full bg-over-media-0",
			ZIndex = props.zIndex or 1
		}

		local v16 = if v10 ~= nil and v10.stickerURI ~= nil then React.createElement(stickerOverlay, {
			overlayEdit = Dash.joinDeep(v10, {
				position = UDim2.fromScale(0.5, 0.5),
				rotation = 0
			})
		}) else nil
		return createElement(view, v14, { ImageOverlay = v16 })
	else
		if stickerOverlays == nil or #stickerOverlays == 0 then
			return nil
		end

		local v13 = v5 == CreationFlowState.Preview

		local createElement = React.createElement
		local v15 = {
			draggable = v13,
			editable = false,
			itemResolution = nil,
			itemSize = v6,
			scaleType = Enum.ScaleType.Crop,
			onOverlayActivated = 0,
			onOverlayDragEnd = 0,
			overlayEdits = 0,
			overlayComponent = 0,
			zIndex = 0
		}

		if not v13 then
			v11 = nil
		end

		v15.onOverlayActivated = v11

		if not v13 then
			v12 = nil
		end

		v15.onOverlayDragEnd = v12
		v15.overlayEdits = stickerOverlays
		v15.overlayComponent = stickerOverlay
		v15.zIndex = props.zIndex
		return createElement(overlayDisplay, v15)
	end
end

return StickerOverlayLayer
