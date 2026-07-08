local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Foundation = require(MomentsCommonParent.Foundation)
local React = require(MomentsCommonParent.React)
local View = Foundation.View
local useCallback = React.useCallback

require(MomentsCommon.Types)

local function TextOverlay(t1: {[any]: any}) -- line: 28
	-- upvalues: React (copy), useCallback (copy), View (copy), Foundation (copy)
	local v9 = React.useRef(nil)
	local v10 = React.useRef(nil)
	local v11 = useCallback(function(_, vector2: Vector2) -- line: 32
		-- upvalues: t1 (copy), v10 (copy)
		if t1.containerRef and t1.containerRef.current then
			v10.current = vector2
		end
	end, { t1.containerRef })
	local v12 = useCallback(function(_, vector2: Vector2) -- line: 38
		-- upvalues: v10 (copy), t1 (copy)
		if vector2 == v10.current and t1.onActivated then
			t1.onActivated()
		end

		if t1.onDragEnd then
			t1.onDragEnd()
		end
	end, {
		t1.onActivated,
		t1.onDragEnd
	})
	local v13 = React.useMemo(function() -- line: 48
		-- upvalues: t1 (copy), React (copy), v9 (copy), v11 (copy), v12 (copy)
		if not t1.draggable then
			return nil
		end

		return React.createElement("UIDragDetector", {
			BoundingBehavior = Enum.UIDragDetectorBoundingBehavior.EntireObject,
			BoundingUI = t1.boundingUI,
			DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane,
			ref = v9,
			ReferenceUIInstance = t1.boundingUI,
			ResponseStyle = Enum.UIDragDetectorResponseStyle.Scale,
			[React.Event.DragStart] = v11,
			[React.Event.DragEnd] = v12
		})
	end, {
		t1.boundingUI,
		t1.draggable,
		v11,
		v12
	})

	return React.createElement(View, {
		tag = "auto-xy anchor-center-center bg-contrast padding-medium position-center-center radius-medium",
		ref = t1.containerRef,
		onActivated = t1.onActivated,
		Position = t1.textOverlayEdit.position,
		Rotation = t1.textOverlayEdit.rotation,
		scale = t1.textOverlayEdit.scale * (t1.additionalScale or 1),
		sizeConstraint = {
			MaxSize = Vector2.new(300, 1e999)
		},
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		ZIndex = t1.textOverlayEdit.zIndex
	}, {
		UIDragDetector = v13,
		TextInput = React.createElement("TextBox", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			ClearTextOnFocus = false,
			ClipsDescendants = true,
			Font = t1.textOverlayEdit.textOverlayStyle.font,
			Interactable = t1.editable == true,
			Text = t1.textOverlayEdit.text,
			TextColor3 = t1.textOverlayEdit.textOverlayStyle.fontColor,
			TextSize = t1.textOverlayEdit.textOverlayStyle.fontSize,
			TextXAlignment = t1.textOverlayEdit.textOverlayStyle.textXAlignment,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = true,
			Size = t1.size,
			ZIndex = t1.textOverlayEdit.zIndex,
			ref = t1.textBoxRef,
			[React.Change.Text] = t1.onTextChanged
		})
	})
end

return TextOverlay
