local parent = script:FindFirstAncestor("MomentsCommon").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local View = Foundation.View

local Image = Foundation.Image

local useCallback = React.useCallback

require(parent.MomentsTypes)

local function StickerOverlay(props)
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
			ReferenceUIInstance = props.referenceUI or props.boundingUI,
			ResponseStyle = Enum.UIDragDetectorResponseStyle.Scale,
			[React.Event.DragStart] = v,
			[React.Event.DragEnd] = v2
		})
	end, { props.boundingUI, props.draggable, props.referenceUI, v, v2 })

	return React.createElement(View, {
		ref = props.containerRef,
		onActivated = props.onActivated,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		Position = props.overlayEdit.position,
		Rotation = props.overlayEdit.rotation,
		scale = props.overlayEdit.scale * (props.additionalScale or 1),
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "position-center-center anchor-center-center auto-xy",
		ZIndex = props.overlayEdit.zIndex
	}, {
		UIDragDetector = uiDragDetector,
		StickerImage = React.createElement(Image, {
			Image = props.overlayEdit.stickerURI,
			Size = UDim2.fromOffset(props.overlayEdit.stickerSize, props.overlayEdit.stickerSize),
			ZIndex = props.overlayEdit.zIndex or 1
		})
	})
end

return StickerOverlay
