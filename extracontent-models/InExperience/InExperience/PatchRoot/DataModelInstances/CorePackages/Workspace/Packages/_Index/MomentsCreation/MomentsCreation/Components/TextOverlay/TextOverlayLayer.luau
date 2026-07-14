local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Dash = require(MomentsCreationParent.Dash)
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Signals = require(MomentsCreationParent.Signals)
local SignalsReact = require(MomentsCreationParent.SignalsReact)
local TextService = game:GetService("TextService")
local View = Foundation.View
local useBinding = React.useBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useSignalState = SignalsReact.useSignalState
local OverlayDisplay = MomentsCommon.Components.OverlayDisplay
local TextOverlay = MomentsCommon.Components.TextOverlay
local TextOverlayDisplay = MomentsCommon.Components.TextOverlayDisplay
local GetFFlagMomentsStickerButton = MomentsCommon.Flags.GetFFlagMomentsStickerButton
local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)

require(MomentsCreation.Types.CreationFlowTypes)
require(MomentsCreationParent.MomentsTypes)

local useOnScreenKeyboardHeight = require(MomentsCreation.Hooks.useOnScreenKeyboardHeight)
local makeDefaultTextOverlayEdit = require(MomentsCreation.Utils.makeDefaultTextOverlayEdit)
local makeTextOverlayEditsForEditor = require(MomentsCreation.Utils.makeTextOverlayEditsForEditor)
local GetFFlagMomentsTextOverlayClampToBounds = require(MomentsCreation.Flags.GetFFlagMomentsTextOverlayClampToBounds)

local function TextOverlayLayer(t1: {[any]: any}) -- line: 74
	-- upvalues: useSignalState (copy), useMemo (copy), Signals (copy), CreationFlowState (copy), useRef (copy), useBinding (copy), useOnScreenKeyboardHeight (copy), useCallback (copy), GetFFlagMomentsStickerButton (copy), Dash (copy), useEffect (copy), makeTextOverlayEditsForEditor (copy), makeDefaultTextOverlayEdit (copy), TextService (copy), React (copy), View (copy), Foundation (copy), TextOverlay (copy), OverlayDisplay (copy), GetFFlagMomentsTextOverlayClampToBounds (copy), TextOverlayDisplay (copy)
	local controller = t1.controller
	local v29 = useSignalState(controller.getStep)
	local v30 = useSignalState(t1.ctx.getItemSize)
	local textOverlays = useSignalState(controller.getComposedEdits).textOverlays
	local v32 = useMemo(function() -- line: 83
		-- upvalues: Signals (copy), controller (copy)
		return Signals.createComputed(function(p1) -- line: 84
			-- upvalues: controller (copy)
			local v57 = controller.getActiveSession(p1)

			if v57 ~= nil then
				return (v57.getDraft(p1))
			end

			return nil
		end)
	end, { controller })
	local v33 = useSignalState(v32)
	local v34 = v29 == CreationFlowState.TextOverlay
	local v35 = v33 and v33[1]
	local v36 = useRef(nil)
	local v37, v38 = useBinding(UDim2.fromOffset(0, 0))
	local v39 = useOnScreenKeyboardHeight()
	local v40 = useCallback(function() -- line: 98
		-- upvalues: v36 (copy)
		if v36.current then
			v36.current:CaptureFocus()
		end
	end, {})
	local v41 = useCallback(function(p2) -- line: 104
		-- upvalues: controller (copy), GetFFlagMomentsStickerButton (copy), Dash (copy)
		local v47 = controller.getActiveSession(false)

		if v47 == nil then
			return
		end

		local v48 = v47.getDraft(false)
		local v49 = v48 and v48[1]

		if v49 == nil then
			return
		end

		local v50 = utf8.len(p2.Text)

		if v50 ~= nil and v50 >= 100 then
			local v51 = utf8.offset(p2.Text, 101)

			if GetFFlagMomentsStickerButton() then
				if v51 then
					p2.Text = string.sub(p2.Text, 1, v51 - 1)
				end
			else
				p2.Text = string.sub(p2.Text, 1, v51 - 1)
			end
		end

		v47.update({ Dash.joinDeep(v49, {
			text = p2.Text
		}) })
	end, { controller })
	local v42 = useCallback(function() -- line: 131
		-- upvalues: controller (copy)
		controller.beginTool("text")
	end, { controller })
	local v43 = useCallback(function(t2: {[any]: any}?) -- line: 135
		-- upvalues: controller (copy)
		controller.updateCommittedEdit("text", t2)
	end, { controller })

	useEffect(function() -- line: 141
		-- upvalues: v34 (copy), controller (copy), makeTextOverlayEditsForEditor (copy), textOverlays (copy), makeDefaultTextOverlayEdit (copy)
		if not v34 then
			return
		end

		local v53 = controller.getActiveSession(false)

		if v53 == nil or v53.getDraft(false) ~= nil then
			return
		end

		v53.update(makeTextOverlayEditsForEditor(textOverlays, makeDefaultTextOverlayEdit(), 1))
	end, {
		v34,
		textOverlays,
		controller
	})

	local v44 = useRef(false)

	useEffect(function() -- line: 157
		-- upvalues: v34 (copy), v44 (copy), v36 (copy), v35 (copy), v40 (copy)
		if not v34 then
			v44.current = false

			if v36.current then
				v36.current:ReleaseFocus()
			end

			return
		end

		if v44.current or v36.current == nil or v35 == nil then
			return
		end

		v40()
		v44.current = true
	end, {
		v34,
		v35,
		v40
	})
	useEffect(function() -- line: 172
		-- upvalues: v34 (copy), v35 (copy), v39 (copy), v38 (copy), TextService (copy), v30 (copy)
		if not v34 or v35 == nil then
			return
		end

		if v39 == 0 then
			v38(UDim2.fromOffset(0, 0))

			return
		end

		local textOverlayStyle = v35.textOverlayStyle
		local TextSize = TextService:GetTextSize("W", textOverlayStyle.fontSize, textOverlayStyle.font, Vector2.new(v30.X, v30.Y))

		v38(UDim2.fromOffset(math.min(TextSize.X * 30, v30.X / 2), (math.min(TextSize.Y * 5, v30.Y / 2))))
	end, {
		v34,
		v35,
		v39,
		v30
	})

	if v34 then
		if v35 == nil then
			return nil
		end

		return React.createElement(View, {
			tag = "size-full bg-over-media-0",
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			},
			ZIndex = t1.zIndex or 1
		}, {
			TextOverlay = React.createElement(TextOverlay, {
				editable = true,
				onActivated = v40,
				size = v37,
				textOverlayEdit = Dash.joinDeep(v35, {
					rotation = 0,
					position = UDim2.fromScale(0.5, 0.5)
				}),
				onTextChanged = v41,
				textBoxRef = v36
			})
		})
	end

	if textOverlays == nil or #textOverlays == 0 then
		return nil
	end

	local v45 = v29 == CreationFlowState.Preview

	if GetFFlagMomentsStickerButton() then
		return React.createElement(OverlayDisplay, {
			editable = false,
			itemResolution = nil,
			clampToBoundsEnabled = GetFFlagMomentsTextOverlayClampToBounds(),
			draggable = v45,
			itemSize = v30,
			scaleType = Enum.ScaleType.Crop,
			onOverlayActivated = if not v45 then nil else v42,
			onOverlayDragEnd = if not v45 then nil else v43,
			overlayEdits = textOverlays,
			overlayComponent = TextOverlay,
			zIndex = t1.zIndex
		})
	end

	return React.createElement(TextOverlayDisplay, {
		editable = false,
		itemResolution = nil,
		clampToBoundsEnabled = GetFFlagMomentsTextOverlayClampToBounds(),
		draggable = v45,
		itemSize = v30,
		scaleType = Enum.ScaleType.Crop,
		onTextOverlayActivated = if not v45 then nil else v42,
		onTextOverlayDragEnd = if not v45 then nil else v43,
		textOverlayEdits = textOverlays,
		zIndex = t1.zIndex
	})
end

return TextOverlayLayer
