local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Dash = require(MomentsCreationParent.Dash)
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Signals = require(MomentsCreationParent.Signals)
local SignalsReact = require(MomentsCreationParent.SignalsReact)
local View = Foundation.View
local useCallback = React.useCallback
local useMemo = React.useMemo
local useSignalState = SignalsReact.useSignalState
local OverlayDisplay = MomentsCommon.Components.OverlayDisplay
local StickerOverlay = MomentsCommon.Components.StickerOverlay
local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)

require(MomentsCreation.Types.CreationFlowTypes)
require(MomentsCreationParent.MomentsTypes)

local function StickerOverlayLayer(t1: {[any]: any}) -- line: 43
	-- upvalues: useSignalState (copy), useMemo (copy), Signals (copy), CreationFlowState (copy), useCallback (copy), React (copy), View (copy), Foundation (copy), StickerOverlay (copy), Dash (copy), OverlayDisplay (copy)
	local controller = t1.controller
	local v19 = useSignalState(controller.getStep)
	local v20 = useSignalState(t1.ctx.getItemSize)
	local stickerOverlays = useSignalState(controller.getComposedEdits).stickerOverlays
	local v22 = useMemo(function() -- line: 52
		-- upvalues: Signals (copy), controller (copy)
		return Signals.createComputed(function(p1) -- line: 53
			-- upvalues: controller (copy)
			local v31 = controller.getActiveSession(p1)

			if v31 ~= nil then
				return (v31.getDraft(p1))
			end

			return nil
		end)
	end, { controller })
	local v23 = useSignalState(v22)
	local v24 = v19 == CreationFlowState.StickerOverlay
	local v25 = v23 and v23[1]
	local v26 = useCallback(function() -- line: 63
		-- upvalues: controller (copy)
		controller.beginTool("sticker")
	end, { controller })
	local v27 = useCallback(function(t2: {[any]: any}?) -- line: 67
		-- upvalues: controller (copy)
		controller.updateCommittedEdit("sticker", t2)
	end, { controller })

	if v24 then
		return React.createElement(View, {
			tag = "size-full bg-over-media-0",
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			},
			ZIndex = t1.zIndex or 1
		}, {
			ImageOverlay = if v25 == nil or v25.stickerURI == nil then nil else React.createElement(StickerOverlay, {
				overlayEdit = Dash.joinDeep(v25, {
					rotation = 0,
					position = UDim2.fromScale(0.5, 0.5)
				})
			})
		})
	end

	if stickerOverlays == nil or #stickerOverlays == 0 then
		return nil
	end

	local v28 = v19 == CreationFlowState.Preview

	return React.createElement(OverlayDisplay, {
		editable = false,
		itemResolution = nil,
		draggable = v28,
		itemSize = v20,
		scaleType = Enum.ScaleType.Crop,
		onOverlayActivated = if not v28 then nil else v26,
		onOverlayDragEnd = if not v28 then nil else v27,
		overlayEdits = stickerOverlays,
		overlayComponent = StickerOverlay,
		zIndex = t1.zIndex
	})
end

return StickerOverlayLayer
