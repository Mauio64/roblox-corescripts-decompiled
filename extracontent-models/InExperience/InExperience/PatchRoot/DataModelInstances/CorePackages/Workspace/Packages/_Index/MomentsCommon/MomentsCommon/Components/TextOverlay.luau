local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local View = Foundation.View
local useCallback = React.useCallback

require(Parent.MomentsTypes)

local function TextOverlay(t1: {[any]: any}) -- line: 32
	-- upvalues: React (copy), useCallback (copy), View (copy), Foundation (copy)
	local v8 = React.useRef(nil)
	local v9 = React.useRef(nil)
	local v10 = useCallback(function(_, vector2: Vector2) -- line: 36
		-- upvalues: t1 (copy), v9 (copy)
		if t1.containerRef and t1.containerRef.current then
			v9.current = vector2
		end
	end, { t1.containerRef })
	local v11 = useCallback(function(_, vector2: Vector2) -- line: 42
		-- upvalues: v9 (copy), t1 (copy)
		if vector2 == v9.current and t1.onActivated then
			t1.onActivated()
		end

		if t1.onDragEnd then
			t1.onDragEnd()
		end
	end, {
		t1.onActivated,
		t1.onDragEnd
	})
	local v12 = React.useMemo(function() -- line: 52
		-- upvalues: t1 (copy), React (copy), v8 (copy), v10 (copy), v11 (copy)
		if not t1.draggable then
			return nil
		end

		return React.createElement("UIDragDetector", {
			BoundingBehavior = Enum.UIDragDetectorBoundingBehavior.EntireObject,
			BoundingUI = t1.boundingUI,
			DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane,
			ref = v8,
			ReferenceUIInstance = t1.referenceUI or t1.boundingUI,
			ResponseStyle = Enum.UIDragDetectorResponseStyle.Scale,
			[React.Event.DragStart] = v10,
			[React.Event.DragEnd] = v11
		})
	end, {
		t1.boundingUI,
		t1.draggable,
		t1.referenceUI,
		v10,
		v11
	})

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center auto-xy padding-medium radius-medium bg-contrast",
		ref = t1.containerRef,
		onActivated = t1.onActivated,
		onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
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
		UIDragDetector = v12,
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
			Selectable = t1.editable == true,
			Size = t1.size,
			ZIndex = t1.textOverlayEdit.zIndex,
			ref = t1.textBoxRef,
			[React.Change.Text] = t1.onTextChanged
		})
	})
end

return TextOverlay
