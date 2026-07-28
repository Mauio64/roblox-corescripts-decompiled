local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local View = Foundation.View
local FoundationImage = Foundation.Image
local useCallback = React.useCallback

require(Parent.MomentsTypes)

local function StickerOverlay(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), useCallback (copy), View (copy), Foundation (copy), FoundationImage (copy)
	local v9 = React.useRef(nil)
	local v10 = React.useRef(nil)
	local v11 = useCallback(function(_, vector2: Vector2) -- line: 34
		-- upvalues: t1 (copy), v10 (copy)
		if t1.containerRef and t1.containerRef.current then
			v10.current = vector2
		end
	end, { t1.containerRef })
	local v12 = useCallback(function(_, vector2: Vector2) -- line: 40
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
	local v13 = React.useMemo(function() -- line: 50
		-- upvalues: t1 (copy), React (copy), v9 (copy), v11 (copy), v12 (copy)
		if not t1.draggable then
			return nil
		end

		return React.createElement("UIDragDetector", {
			BoundingBehavior = Enum.UIDragDetectorBoundingBehavior.EntireObject,
			BoundingUI = t1.boundingUI,
			DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane,
			ref = v9,
			ReferenceUIInstance = t1.referenceUI or t1.boundingUI,
			ResponseStyle = Enum.UIDragDetectorResponseStyle.Scale,
			[React.Event.DragStart] = v11,
			[React.Event.DragEnd] = v12
		})
	end, {
		t1.boundingUI,
		t1.draggable,
		t1.referenceUI,
		v11,
		v12
	})

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center auto-xy",
		ref = t1.containerRef,
		onActivated = t1.onActivated,
		onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
		Position = t1.overlayEdit.position,
		Rotation = t1.overlayEdit.rotation,
		scale = t1.overlayEdit.scale * (t1.additionalScale or 1),
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		ZIndex = t1.overlayEdit.zIndex
	}, {
		UIDragDetector = v13,
		StickerImage = React.createElement(FoundationImage, {
			Image = t1.overlayEdit.stickerURI,
			Size = UDim2.fromOffset(t1.overlayEdit.stickerSize, t1.overlayEdit.stickerSize),
			ZIndex = t1.overlayEdit.zIndex or 1
		})
	})
end

return StickerOverlay
