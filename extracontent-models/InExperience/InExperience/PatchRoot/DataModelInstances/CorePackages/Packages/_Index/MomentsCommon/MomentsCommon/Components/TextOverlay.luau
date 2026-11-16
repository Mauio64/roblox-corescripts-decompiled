local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local View = Foundation.View

local useCallback = React.useCallback

require(MomentsCommon.Types)

local function TextOverlay(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v = useCallback(function(_, current: Vector2)
		if props.containerRef and props.containerRef.current then
			ref2.current = current
		end
	end, { props.containerRef })

	local v2 = useCallback(function(_, vector2: Vector2)
		if ref2.current == vector2 and props.onActivated then
			props.onActivated()
		end

		if props.onDragEnd then
			props.onDragEnd()
		end
	end, { props.onActivated, props.onDragEnd })

	local uiDragDetector = React.useMemo(function()
		if not props.draggable then
			return nil
		end

		return React.createElement("UIDragDetector", {
			BoundingBehavior = Enum.UIDragDetectorBoundingBehavior.EntireObject,
			BoundingUI = props.boundingUI,
			DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane,
			ref = ref,
			ReferenceUIInstance = props.boundingUI,
			ResponseStyle = Enum.UIDragDetectorResponseStyle.Scale,
			[React.Event.DragStart] = v,
			[React.Event.DragEnd] = v2
		})
	end, { props.boundingUI, props.draggable, v, v2 })

	return React.createElement(View, {
		ref = props.containerRef,
		onActivated = props.onActivated,
		Position = props.textOverlayEdit.position,
		Rotation = props.textOverlayEdit.rotation,
		scale = props.textOverlayEdit.scale * (props.additionalScale or 1),
		sizeConstraint = { MaxSize = Vector2.new(300, 1e999) },
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "auto-xy anchor-center-center bg-contrast padding-medium position-center-center radius-medium",
		ZIndex = props.textOverlayEdit.zIndex
	}, {
		UIDragDetector = uiDragDetector,
		TextInput = React.createElement("TextBox", {
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			ClearTextOnFocus = false,
			ClipsDescendants = true,
			Font = props.textOverlayEdit.textOverlayStyle.font,
			Interactable = props.editable == true,
			Text = props.textOverlayEdit.text,
			TextColor3 = props.textOverlayEdit.textOverlayStyle.fontColor,
			TextSize = props.textOverlayEdit.textOverlayStyle.fontSize,
			TextXAlignment = props.textOverlayEdit.textOverlayStyle.textXAlignment,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextWrapped = true,
			Size = props.size,
			ZIndex = props.textOverlayEdit.zIndex,
			ref = props.textBoxRef,
			[React.Change.Text] = props.onTextChanged
		})
	})
end

return TextOverlay
