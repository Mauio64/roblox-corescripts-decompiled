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
local TextOverlay = MomentsCommon.Components.TextOverlay
local TextOverlayDisplay = MomentsCommon.Components.TextOverlayDisplay
local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)

require(MomentsCreation.Types.CreationFlowTypes)
require(MomentsCreationParent.MomentsTypes)

local useOnScreenKeyboardHeight = require(MomentsCreation.Hooks.useOnScreenKeyboardHeight)
local makeDefaultTextOverlayEdit = require(MomentsCreation.Utils.makeDefaultTextOverlayEdit)
local makeTextOverlayEditsForEditor = require(MomentsCreation.Utils.makeTextOverlayEditsForEditor)

local function TextOverlayLayer(t1: {[any]: any}) -- line: 70
	-- upvalues: useSignalState (copy), useMemo (copy), Signals (copy), CreationFlowState (copy), useRef (copy), useBinding (copy), useOnScreenKeyboardHeight (copy), useCallback (copy), Dash (copy), useEffect (copy), makeTextOverlayEditsForEditor (copy), makeDefaultTextOverlayEdit (copy), TextService (copy), React (copy), View (copy), Foundation (copy), TextOverlay (copy), TextOverlayDisplay (copy)
	local controller = t1.controller
	local v26 = useSignalState(controller.getStep)
	local v27 = useSignalState(t1.ctx.getItemSize)
	local textOverlays = useSignalState(controller.getComposedEdits).textOverlays
	local v29 = useMemo(function() -- line: 79
		-- upvalues: Signals (copy), controller (copy)
		return Signals.createComputed(function(p1) -- line: 80
			-- upvalues: controller (copy)
			local v54 = controller.getActiveSession(p1)

			if v54 ~= nil then
				return (v54.getDraft(p1))
			end

			return nil
		end)
	end, { controller })
	local v30 = useSignalState(v29)
	local v31 = v26 == CreationFlowState.TextOverlay
	local v32 = v30 and v30[1]
	local v33 = useRef(nil)
	local v34, v35 = useBinding(UDim2.fromOffset(0, 0))
	local v36 = useOnScreenKeyboardHeight()
	local v37 = useCallback(function() -- line: 94
		-- upvalues: v33 (copy)
		if v33.current then
			v33.current:CaptureFocus()
		end
	end, {})
	local v38 = useCallback(function(p2) -- line: 100
		-- upvalues: controller (copy), Dash (copy)
		local v44 = controller.getActiveSession(false)

		if v44 == nil then
			return
		end

		local v45 = v44.getDraft(false)
		local v46 = v45 and v45[1]

		if v46 == nil then
			return
		end

		local v47 = utf8.len(p2.Text)

		if v47 ~= nil and v47 >= 100 then
			local v48 = utf8.offset(p2.Text, 101)

			p2.Text = string.sub(p2.Text, 1, v48 - 1)
		end

		v44.update({ Dash.joinDeep(v46, {
			text = p2.Text
		}) })
	end, { controller })
	local v39 = useCallback(function() -- line: 121
		-- upvalues: controller (copy)
		controller.beginTool("text")
	end, { controller })
	local v40 = useCallback(function(t2: {[any]: any}?) -- line: 125
		-- upvalues: controller (copy)
		controller.updateCommittedEdit("text", t2)
	end, { controller })

	useEffect(function() -- line: 131
		-- upvalues: v31 (copy), controller (copy), makeTextOverlayEditsForEditor (copy), textOverlays (copy), makeDefaultTextOverlayEdit (copy)
		if not v31 then
			return
		end

		local v50 = controller.getActiveSession(false)

		if v50 == nil or v50.getDraft(false) ~= nil then
			return
		end

		v50.update(makeTextOverlayEditsForEditor(textOverlays, makeDefaultTextOverlayEdit(), 1))
	end, {
		v31,
		textOverlays,
		controller
	})

	local v41 = useRef(false)

	useEffect(function() -- line: 147
		-- upvalues: v31 (copy), v41 (copy), v33 (copy), v32 (copy), v37 (copy)
		if not v31 then
			v41.current = false

			if v33.current then
				v33.current:ReleaseFocus()
			end

			return
		end

		if v41.current or v33.current == nil or v32 == nil then
			return
		end

		v37()
		v41.current = true
	end, {
		v31,
		v32,
		v37
	})
	useEffect(function() -- line: 162
		-- upvalues: v31 (copy), v32 (copy), v36 (copy), v35 (copy), TextService (copy), v27 (copy)
		if not v31 or v32 == nil then
			return
		end

		if v36 == 0 then
			v35(UDim2.fromOffset(0, 0))

			return
		end

		local textOverlayStyle = v32.textOverlayStyle
		local TextSize = TextService:GetTextSize("W", textOverlayStyle.fontSize, textOverlayStyle.font, Vector2.new(v27.X, v27.Y))

		v35(UDim2.fromOffset(math.min(TextSize.X * 30, v27.X / 2), (math.min(TextSize.Y * 5, v27.Y / 2))))
	end, {
		v31,
		v32,
		v36,
		v27
	})

	if v31 then
		if v32 == nil then
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
				onActivated = v37,
				size = v34,
				textOverlayEdit = Dash.joinDeep(v32, {
					rotation = 0,
					position = UDim2.fromScale(0.5, 0.5)
				}),
				onTextChanged = v38,
				textBoxRef = v33
			})
		})
	end

	if textOverlays == nil or #textOverlays == 0 then
		return nil
	end

	local v42 = v26 == CreationFlowState.Preview

	return React.createElement(TextOverlayDisplay, {
		editable = false,
		itemResolution = nil,
		draggable = v42,
		itemSize = v27,
		scaleType = Enum.ScaleType.Crop,
		onTextOverlayActivated = if not v42 then nil else v39,
		onTextOverlayDragEnd = if not v42 then nil else v40,
		textOverlayEdits = textOverlays,
		zIndex = t1.zIndex
	})
end

return TextOverlayLayer
