local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View

local useCallback = React.useCallback
local useMemo = React.useMemo
local useSignalState = SignalsReact.useSignalState

local OverlayDisplay = MomentsCommon.Components.OverlayDisplay
local StickerOverlay = MomentsCommon.Components.StickerOverlay

local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
require(MomentsCreation.Types.CreationFlowTypes)
require(parent.MomentsTypes)

local function StickerOverlayLayer(props)
	local controller = props.controller

	local v = useSignalState(controller.getStep)
	local itemSize = useSignalState(props.ctx.getItemSize)
	local stickerOverlays = useSignalState(controller.getComposedEdits).stickerOverlays

	local v2 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p)
			local activeSession = controller.getActiveSession(p)

			if activeSession == nil then
				return nil
			end

			return (activeSession.getDraft(p))
		end)
	end, { controller })))

	local v3 = v == CreationFlowState.StickerOverlay
	local v4 = v2 and v2[1]

	local onOverlayActivated = useCallback(function()
		controller.beginTool("sticker")
	end, { controller })

	local onOverlayDragEnd = useCallback(function(p)
		controller.updateCommittedEdit("sticker", p)
	end, { controller })

	if v3 then
		local createElement = React.createElement
		local v5 = {
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = "size-full bg-over-media-0",
			ZIndex = props.zIndex or 1
		}
		local imageOverlay

		if not (v4 == nil or v4.stickerURI == nil) then
			imageOverlay = React.createElement(StickerOverlay, {
				overlayEdit = Dash.joinDeep(v4, {
					position = UDim2.fromScale(0.5, 0.5),
					rotation = 0
				})
			})
		end

		return createElement(View, v5, { ImageOverlay = imageOverlay })
	else
		if stickerOverlays == nil or #stickerOverlays == 0 then
			return nil
		end

		local draggable = v == CreationFlowState.Preview

		local createElement = React.createElement
		local v5 = {
			draggable = draggable,
			editable = false,
			itemResolution = nil,
			itemSize = itemSize,
			scaleType = Enum.ScaleType.Crop,
			onOverlayActivated = 0,
			onOverlayDragEnd = 0,
			overlayEdits = 0,
			overlayComponent = 0,
			zIndex = 0
		}

		if not draggable then
			onOverlayActivated = nil
		end

		v5.onOverlayActivated = onOverlayActivated

		if not draggable then
			onOverlayDragEnd = nil
		end

		v5.onOverlayDragEnd = onOverlayDragEnd
		v5.overlayEdits = stickerOverlays
		v5.overlayComponent = StickerOverlay
		v5.zIndex = props.zIndex
		return createElement(OverlayDisplay, v5)
	end
end

return StickerOverlayLayer
