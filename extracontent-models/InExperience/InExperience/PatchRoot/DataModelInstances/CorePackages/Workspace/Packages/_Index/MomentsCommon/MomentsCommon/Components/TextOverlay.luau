local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local GetFFlagMomentsStickerButton = require(MomentsCommon.Flags.GetFFlagMomentsStickerButton)
local Foundation = require(MomentsCommonParent.Foundation)
local React = require(MomentsCommonParent.React)
local View = Foundation.View
local useCallback = React.useCallback

require(MomentsCommonParent.MomentsTypes)

local function TextOverlay(t1: {[any]: any}) -- line: 34
	-- upvalues: GetFFlagMomentsStickerButton (copy), React (copy), useCallback (copy), View (copy), Foundation (copy)
	local v10 = if not GetFFlagMomentsStickerButton() then t1.textOverlayEdit else t1.overlayEdit or t1.textOverlayEdit
	local v11 = React.useRef(nil)
	local v12 = React.useRef(nil)
	local v13 = useCallback(function(_, vector2: Vector2) -- line: 45
		-- upvalues: t1 (copy), v12 (copy)
		if t1.containerRef and t1.containerRef.current then
			v12.current = vector2
		end
	end, { t1.containerRef })
	local v14 = useCallback(function(_, vector2: Vector2) -- line: 51
		-- upvalues: v12 (copy), t1 (copy)
		if vector2 == v12.current and t1.onActivated then
			t1.onActivated()
		end

		if t1.onDragEnd then
			t1.onDragEnd()
		end
	end, {
		t1.onActivated,
		t1.onDragEnd
	})
	local v15 = React.useMemo(function() -- line: 61
		-- upvalues: t1 (copy), React (copy), v11 (copy), v13 (copy), v14 (copy)
		if not t1.draggable then
			return nil
		end

		return React.createElement("UIDragDetector", {
			BoundingBehavior = Enum.UIDragDetectorBoundingBehavior.EntireObject,
			BoundingUI = t1.boundingUI,
			DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane,
			ref = v11,
			ReferenceUIInstance = t1.referenceUI or t1.boundingUI,
			ResponseStyle = Enum.UIDragDetectorResponseStyle.Scale,
			[React.Event.DragStart] = v13,
			[React.Event.DragEnd] = v14
		})
	end, {
		t1.boundingUI,
		t1.draggable,
		t1.referenceUI,
		v13,
		v14
	})

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center auto-xy padding-medium radius-medium bg-contrast",
		ref = t1.containerRef,
		onActivated = t1.onActivated,
		onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
		Position = v10.position,
		Rotation = v10.rotation,
		scale = v10.scale * (t1.additionalScale or 1),
		sizeConstraint = {
			MaxSize = Vector2.new(300, 1e999)
		},
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		ZIndex = v10.zIndex
	}, {
		UIDragDetector = v15,
		TextInput = React.createElement("TextBox", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			ClearTextOnFocus = false,
			ClipsDescendants = true,
			Font = v10.textOverlayStyle.font,
			Interactable = t1.editable == true,
			Text = v10.text,
			TextColor3 = v10.textOverlayStyle.fontColor,
			TextSize = v10.textOverlayStyle.fontSize,
			TextXAlignment = v10.textOverlayStyle.textXAlignment,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = true,
			Selectable = t1.editable == true,
			Size = t1.size,
			ZIndex = v10.zIndex,
			ref = t1.textBoxRef,
			[React.Change.Text] = t1.onTextChanged
		})
	})
end

return TextOverlay
