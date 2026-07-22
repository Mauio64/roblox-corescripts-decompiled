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
local getScale = MomentsCommon.Utils.getScale
local GetFFlagMomentsStickerButton = MomentsCommon.Flags.GetFFlagMomentsStickerButton
local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)

require(MomentsCreation.Types.CreationFlowTypes)
require(MomentsCreationParent.MomentsTypes)

local useOnScreenKeyboardHeight = require(MomentsCreation.Hooks.useOnScreenKeyboardHeight)
local makeDefaultTextOverlayEdit = require(MomentsCreation.Utils.makeDefaultTextOverlayEdit)
local makeTextOverlayEditsForEditor = require(MomentsCreation.Utils.makeTextOverlayEditsForEditor)
local GetFFlagMomentsTextOverlayClampToBounds = require(MomentsCreation.Flags.GetFFlagMomentsTextOverlayClampToBounds)
local GetFFlagMomentsCreationTextOverlayResolutionScale = require(MomentsCreation.Flags.GetFFlagMomentsCreationTextOverlayResolutionScale)

local function TextOverlayLayer(t1: {[any]: any}) -- line: 77
	-- upvalues: useSignalState (copy), GetFFlagMomentsCreationTextOverlayResolutionScale (copy), getScale (copy), useMemo (copy), Signals (copy), CreationFlowState (copy), useRef (copy), useBinding (copy), useOnScreenKeyboardHeight (copy), useCallback (copy), GetFFlagMomentsStickerButton (copy), Dash (copy), useEffect (copy), makeTextOverlayEditsForEditor (copy), makeDefaultTextOverlayEdit (copy), TextService (copy), React (copy), View (copy), Foundation (copy), TextOverlay (copy), OverlayDisplay (copy), GetFFlagMomentsTextOverlayClampToBounds (copy), TextOverlayDisplay (copy)
	local controller = t1.controller
	local v31 = useSignalState(controller.getStep)
	local v32 = useSignalState(t1.ctx.getItemSize)
	local v33 = useSignalState(t1.ctx.getItemResolution)
	local textOverlays = useSignalState(controller.getComposedEdits).textOverlays
	local v35 = GetFFlagMomentsCreationTextOverlayResolutionScale()
	local v36 = not v35 and 1 or getScale(v32, v33, Enum.ScaleType.Crop)
	local v37 = useMemo(function() -- line: 94
		-- upvalues: Signals (copy), controller (copy)
		return Signals.createComputed(function(p1) -- line: 95
			-- upvalues: controller (copy)
			local v62 = controller.getActiveSession(p1)

			if v62 ~= nil then
				return (v62.getDraft(p1))
			end

			return nil
		end)
	end, { controller })
	local v38 = useSignalState(v37)
	local v39 = v31 == CreationFlowState.TextOverlay
	local v40 = v38 and v38[1]
	local v41 = useRef(nil)
	local v42, v43 = useBinding(UDim2.fromOffset(0, 0))
	local v44 = useOnScreenKeyboardHeight()
	local v45 = useCallback(function() -- line: 109
		-- upvalues: v41 (copy)
		if v41.current then
			v41.current:CaptureFocus()
		end
	end, {})
	local v46 = useCallback(function(p2) -- line: 115
		-- upvalues: controller (copy), GetFFlagMomentsStickerButton (copy), Dash (copy)
		local v52 = controller.getActiveSession(false)

		if v52 == nil then
			return
		end

		local v53 = v52.getDraft(false)
		local v54 = v53 and v53[1]

		if v54 == nil then
			return
		end

		local v55 = utf8.len(p2.Text)

		if v55 ~= nil and v55 >= 100 then
			local v56 = utf8.offset(p2.Text, 101)

			if GetFFlagMomentsStickerButton() then
				if v56 then
					p2.Text = string.sub(p2.Text, 1, v56 - 1)
				end
			else
				p2.Text = string.sub(p2.Text, 1, v56 - 1)
			end
		end

		v52.update({ Dash.joinDeep(v54, {
			text = p2.Text
		}) })
	end, { controller })
	local v47 = useCallback(function() -- line: 142
		-- upvalues: controller (copy)
		controller.beginTool("text")
	end, { controller })
	local v48 = useCallback(function(t2: {[any]: any}?) -- line: 146
		-- upvalues: controller (copy)
		controller.updateCommittedEdit("text", t2)
	end, { controller })

	useEffect(function() -- line: 152
		-- upvalues: v39 (copy), controller (copy), makeTextOverlayEditsForEditor (copy), textOverlays (copy), makeDefaultTextOverlayEdit (copy), v36 (copy)
		if not v39 then
			return
		end

		local v58 = controller.getActiveSession(false)

		if v58 == nil or v58.getDraft(false) ~= nil then
			return
		end

		v58.update(makeTextOverlayEditsForEditor(textOverlays, makeDefaultTextOverlayEdit(), v36))
	end, {
		v39,
		textOverlays,
		controller,
		v36
	})

	local v49 = useRef(false)

	useEffect(function() -- line: 168
		-- upvalues: v39 (copy), v49 (copy), v41 (copy), v40 (copy), v45 (copy)
		if not v39 then
			v49.current = false

			if v41.current then
				v41.current:ReleaseFocus()
			end

			return
		end

		if v49.current or v41.current == nil or v40 == nil then
			return
		end

		v45()
		v49.current = true
	end, {
		v39,
		v40,
		v45
	})
	useEffect(function() -- line: 183
		-- upvalues: v39 (copy), v40 (copy), v44 (copy), v43 (copy), TextService (copy), v32 (copy)
		if not v39 or v40 == nil then
			return
		end

		if v44 == 0 then
			v43(UDim2.fromOffset(0, 0))

			return
		end

		local textOverlayStyle = v40.textOverlayStyle
		local TextSize = TextService:GetTextSize("W", textOverlayStyle.fontSize, textOverlayStyle.font, Vector2.new(v32.X, v32.Y))

		v43(UDim2.fromOffset(math.min(TextSize.X * 30, v32.X / 2), (math.min(TextSize.Y * 5, v32.Y / 2))))
	end, {
		v39,
		v40,
		v44,
		v32
	})

	if v39 then
		if v40 == nil then
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
				onActivated = v45,
				size = v42,
				textOverlayEdit = Dash.joinDeep(v40, {
					rotation = 0,
					position = UDim2.fromScale(0.5, 0.5)
				}),
				onTextChanged = v46,
				textBoxRef = v41
			})
		})
	end

	if textOverlays == nil or #textOverlays == 0 then
		return nil
	end

	local v50 = v31 == CreationFlowState.Preview

	if GetFFlagMomentsStickerButton() then
		return React.createElement(OverlayDisplay, {
			editable = false,
			clampToBoundsEnabled = GetFFlagMomentsTextOverlayClampToBounds(),
			draggable = v50,
			itemResolution = if not v35 then nil else v33,
			itemSize = v32,
			scaleType = Enum.ScaleType.Crop,
			onOverlayActivated = if not v50 then nil else v47,
			onOverlayDragEnd = if not v50 then nil else v48,
			overlayEdits = textOverlays,
			overlayComponent = TextOverlay,
			zIndex = t1.zIndex
		})
	end

	return React.createElement(TextOverlayDisplay, {
		editable = false,
		clampToBoundsEnabled = GetFFlagMomentsTextOverlayClampToBounds(),
		draggable = v50,
		itemResolution = if not v35 then nil else v33,
		itemSize = v32,
		scaleType = Enum.ScaleType.Crop,
		onTextOverlayActivated = if not v50 then nil else v47,
		onTextOverlayDragEnd = if not v50 then nil else v48,
		textOverlayEdits = textOverlays,
		zIndex = t1.zIndex
	})
end

return TextOverlayLayer
