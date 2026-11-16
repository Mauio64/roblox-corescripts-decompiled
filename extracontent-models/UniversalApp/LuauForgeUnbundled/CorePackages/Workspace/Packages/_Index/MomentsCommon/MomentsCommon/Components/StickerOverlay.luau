local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local view = Foundation.View

local image = Foundation.Image

local useCallback = React.useCallback

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsTypes")

local function StickerOverlay(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v5 = useCallback(function(p2, current)
		if props.containerRef and props.containerRef.current then
			ref2.current = current
		end
	end, { props.containerRef })

	local v6 = useCallback(function(p2, p3)
		if ref2.current == p3 and props.onActivated then
			props.onActivated()
		end

		if props.onDragEnd then
			props.onDragEnd()
		end
	end, { props.onActivated, props.onDragEnd })

	local v7 = React.useMemo(function()
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
			[React.Event.DragStart] = v5,
			[React.Event.DragEnd] = v6
		})
	end, { props.boundingUI, props.draggable, props.referenceUI, v5, v6 })

	return React.createElement(view, {
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
		UIDragDetector = v7,
		StickerImage = React.createElement(image, {
			Image = props.overlayEdit.stickerURI,
			Size = UDim2.fromOffset(props.overlayEdit.stickerSize, props.overlayEdit.stickerSize),
			ZIndex = props.overlayEdit.zIndex or 1
		})
	})
end

return StickerOverlay
