local ViewRecyclerReact = script:FindFirstAncestor("ViewRecyclerReact")
local ViewRecycler = require(ViewRecyclerReact.Parent.ViewRecycler)
local ViewRecyclerRoblox = require(ViewRecyclerReact.Parent.ViewRecyclerRoblox)

local Axis = ViewRecycler.Axis
local React = require(ViewRecyclerReact.Parent.React)
local ScrollbarOverlay = ViewRecyclerRoblox.Internal.ScrollbarOverlay

local createElement = React.createElement

local function VirtualListShell(props)
	local ref = React.useRef(nil)
	local function refreshScrollBar() -- 2 equivalent calls inferred from this helper
		local current = ref.current

		if current ~= nil then
			ref.current = nil
			current()
		end

		local current2 = props.internalRef.current
		local current3 = props.viewportOverlayRef.current

		if current2 ~= nil and current3 ~= nil then
			ref.current = ScrollbarOverlay.connect(current2, current3, props.axis)
		end
	end
	local v = {}
	v.Size = UDim2.fromScale(1, 1)
	local scrollingDirection

	if props.axis == Axis.X then
		scrollingDirection = Enum.ScrollingDirection.X
	else
		scrollingDirection = Enum.ScrollingDirection.Y
	end

	v.ScrollingDirection = scrollingDirection
	v[React.Tag] = props.tag

	local scrollingFrameProps = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }

	local v2 = {
		CanvasSize = true,
		CanvasPosition = true,
		ref = true,
		[React.Tag] = true,
		[React.Change.AbsoluteWindowSize] = true,
		[React.Change.CanvasPosition] = true
	}

	if props.scrollingFrameProps ~= nil then
		for k, scrollingFrameProp in props.scrollingFrameProps do
			if v[k] ~= nil or v2[k] then
				error(`VirtualList: {tostring(k)} is already used by ViewRecycler`)
			end

			if k == "AnchorPoint" or k == "LayoutOrder" or k == "Position" or k == "Rotation" then
				scrollingFrameProps[k] = scrollingFrameProp
			else
				v[k] = scrollingFrameProp
			end
		end
	end

	if v.Visible ~= nil then
		scrollingFrameProps.Visible = v.Visible
	end

	if v.ZIndex ~= nil then
		scrollingFrameProps.ZIndex = v.ZIndex
	end

	v.ref = React.useCallback(function(current)
		props.internalRef.current = current
		props.onScrollingFrameChanged(current)
		refreshScrollBar() -- inferred equivalent call
	end, { props.axis, props.internalRef, props.onScrollingFrameChanged, props.viewportOverlayRef })

	local ref2 = React.useCallback(function(current)
		props.viewportOverlayRef.current = current
		props.onViewportOverlayChanged(current)
		refreshScrollBar() -- inferred equivalent call
	end, { props.axis, props.internalRef, props.onViewportOverlayChanged, props.viewportOverlayRef })

	return createElement("Frame", scrollingFrameProps, {
		ScrollingFrame = createElement("ScrollingFrame", v),
		ViewRecyclerOverlay = createElement("Frame", {
			Active = false,
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Name = "ViewRecyclerOverlay",
			Selectable = false,
			ZIndex = v.ZIndex,
			ref = ref2
		})
	})
end

return VirtualListShell
