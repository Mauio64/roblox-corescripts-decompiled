local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")

local view = Foundation.View
local divider = Foundation.Divider
local scrollView = Foundation.ScrollView
local visibility = Foundation.Enums.Visibility

local v5 = {
	ScrollingDirection = Enum.ScrollingDirection.Y,
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	CanvasSize = UDim2.fromScale(0, 0),
	scrollBarVisibility = visibility.Auto
}

local function renderScrollView(props)
	return React.createElement(scrollView, {
		tag = "grow size-full-0",
		LayoutOrder = props.scrollLayoutOrder,
		scroll = v5,
		selection = { Selectable = false },
		onAbsoluteCanvasSizeChanged = props.onAbsoluteCanvasSizeChanged,
		onAbsoluteWindowSizeChanged = props.onAbsoluteWindowSizeChanged
	}, {
		Content = React.createElement(
			view,
			{ tag = "col size-full-0 auto-y padding-bottom-xlarge" },
			props.contentChildren
		)
	})
end

local function hasVerticalScrollOverflow(p2): boolean
	return p2.AbsoluteCanvasSize.Y > p2.AbsoluteWindowSize.Y + 1
end

local function ScrollSection(props)
	local pinHeader = props.pinHeader
	local useInternalScroll = props.useInternalScroll
	local children = props.children

	local state, setState = React.useState(false)

	local v6 = React.useCallback(function(p2)
		setState(p2.AbsoluteCanvasSize.Y > p2.AbsoluteWindowSize.Y + 1)
	end, {})

	local v7 = React.useCallback(function(p2)
		v6(p2)
	end, { v6 })

	local v8 = React.useCallback(function(p2)
		v6(p2)
	end, { v6 })
	local v9

	if state then
		v9 = React.createElement(divider, {
			Size = UDim2.new(1, 0, 0, 1),
			LayoutOrder = 2
		})
	end

	local v10

	if props.header then
		v10 = React.createElement(view, { tag = "auto-xy", LayoutOrder = 1 }, props.header)
	end

	local v11 = { onAbsoluteCanvasSizeChanged = v7, onAbsoluteWindowSizeChanged = v8 }
	local v12 = pinHeader and v10 ~= nil
	local v13

	if useInternalScroll then
		if v12 then
			v13 = {
				Header = v10,
				ScrollContent = renderScrollView({
					contentChildren = children or {},
					scrollLayoutOrder = 2,
					onAbsoluteCanvasSizeChanged = v11.onAbsoluteCanvasSizeChanged,
					onAbsoluteWindowSizeChanged = v11.onAbsoluteWindowSizeChanged
				})
			}
		else
			v13 = { ScrollContent = 0 }

			local v17 = if children then React.createElement(React.Fragment, nil, children) else nil
			v13.ScrollContent = renderScrollView({
				contentChildren = { Header = v10, Body = v17 },
				scrollLayoutOrder = 1,
				onAbsoluteCanvasSizeChanged = v11.onAbsoluteCanvasSizeChanged,
				onAbsoluteWindowSizeChanged = v11.onAbsoluteWindowSizeChanged
			})
		end
	else
		v13 = { StaticContent = 0 }
		local createElement = React.createElement
		local v17 = if not (v12 or not v10) then v10 else nil
		local v18 = if children then React.createElement(React.Fragment, nil, children) else nil
		v13.StaticContent = createElement(view, {
			tag = "col size-full-0 auto-y padding-bottom-xlarge",
			LayoutOrder = v12 and 2 or 1
		}, { Header = v17, Body = v18 })
	end

	local v14 = not useInternalScroll and v12 and {
		Header = v10,
		StaticContent = v13.StaticContent
	} or v13

	local createElement = React.createElement
	local v16 = {
		tag = {
			["col size-full-0 padding-top-xlarge"] = true,
			grow = useInternalScroll,
			["auto-y"] = not useInternalScroll
		},
		LayoutOrder = props.layoutOrder
	}
	local v17 = {
		Inner = React.createElement(view, {
			tag = {
				["col gap-small size-full-0"] = true,
				grow = useInternalScroll,
				["auto-y"] = not useInternalScroll
			},
			LayoutOrder = 1
		}, v14),
		ScrollAffordanceDivider = 0
	}

	if not useInternalScroll then
		v9 = nil
	end

	v17.ScrollAffordanceDivider = v9
	return createElement(view, v16, v17)
end

return ScrollSection
