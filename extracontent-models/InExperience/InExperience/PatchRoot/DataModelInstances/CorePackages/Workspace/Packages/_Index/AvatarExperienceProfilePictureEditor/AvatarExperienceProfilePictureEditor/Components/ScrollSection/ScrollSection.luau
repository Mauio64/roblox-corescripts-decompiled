local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Divider = Foundation.Divider
local ScrollView = Foundation.ScrollView
local Visibility = Foundation.Enums.Visibility

local scroll = {
	ScrollingDirection = Enum.ScrollingDirection.Y,
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	CanvasSize = UDim2.fromScale(0, 0),
	scrollBarVisibility = Visibility.Auto
}

local function renderScrollView(props)
	return React.createElement(ScrollView, {
		tag = "grow size-full-0",
		LayoutOrder = props.scrollLayoutOrder,
		scroll = scroll,
		selection = { Selectable = false },
		onAbsoluteCanvasSizeChanged = props.onAbsoluteCanvasSizeChanged,
		onAbsoluteWindowSizeChanged = props.onAbsoluteWindowSizeChanged
	}, {
		Content = React.createElement(
			View,
			{ tag = "col size-full-0 auto-y padding-bottom-xlarge" },
			props.contentChildren
		)
	})
end

local function hasVerticalScrollOverflow(p): boolean -- 1 equivalent call inferred from this helper
	return p.AbsoluteCanvasSize.Y > p.AbsoluteWindowSize.Y + 1
end

local function ScrollSection(props)
	local pinHeader = props.pinHeader
	local useInternalScroll = props.useInternalScroll
	local children = props.children

	local state, setState = React.useState(false)

	local v = React.useCallback(function(p)
		setState(hasVerticalScrollOverflow(p)) -- inferred equivalent call
	end, {})

	local onAbsoluteCanvasSizeChanged = React.useCallback(function(p)
		v(p)
	end, { v })

	local onAbsoluteWindowSizeChanged = React.useCallback(function(p)
		v(p)
	end, { v })
	local scrollAffordanceDivider

	if state then
		scrollAffordanceDivider = React.createElement(Divider, {
			Size = UDim2.new(1, 0, 0, 1),
			LayoutOrder = 2
		})
	end

	local header

	if props.header then
		header = React.createElement(View, { tag = "auto-xy", LayoutOrder = 1 }, props.header)
	end

	local v2 = {
		onAbsoluteCanvasSizeChanged = onAbsoluteCanvasSizeChanged,
		onAbsoluteWindowSizeChanged = onAbsoluteWindowSizeChanged
	}
	local v3 = pinHeader and header ~= nil
	local v4

	if useInternalScroll then
		if v3 then
			v4 = {
				Header = header,
				ScrollContent = renderScrollView({
					contentChildren = children or {},
					scrollLayoutOrder = 2,
					onAbsoluteCanvasSizeChanged = v2.onAbsoluteCanvasSizeChanged,
					onAbsoluteWindowSizeChanged = v2.onAbsoluteWindowSizeChanged
				})
			}
		else
			v4 = { ScrollContent = 0 }
			local body

			if children then
				body = React.createElement(React.Fragment, nil, children)
			end

			v4.ScrollContent = renderScrollView({
				contentChildren = { Header = header, Body = body },
				scrollLayoutOrder = 1,
				onAbsoluteCanvasSizeChanged = v2.onAbsoluteCanvasSizeChanged,
				onAbsoluteWindowSizeChanged = v2.onAbsoluteWindowSizeChanged
			})
		end
	else
		v4 = { StaticContent = 0 }
		local createElement = React.createElement
		local header2

		if not (v3 or not header) then
			header2 = header
		end

		local body

		if children then
			body = React.createElement(React.Fragment, nil, children)
		end

		v4.StaticContent = createElement(View, {
			tag = "col size-full-0 auto-y padding-bottom-xlarge",
			LayoutOrder = v3 and 2 or 1
		}, { Header = header2, Body = body })
	end

	local v5 = not useInternalScroll and v3 and {
		Header = header,
		StaticContent = v4.StaticContent
	} or v4

	local createElement = React.createElement
	local v6 = {
		tag = {
			["col size-full-0 padding-top-xlarge"] = true,
			grow = useInternalScroll,
			["auto-y"] = not useInternalScroll
		},
		LayoutOrder = props.layoutOrder
	}
	local v7 = {
		Inner = React.createElement(View, {
			tag = {
				["col gap-small size-full-0"] = true,
				grow = useInternalScroll,
				["auto-y"] = not useInternalScroll
			},
			LayoutOrder = 1
		}, v5),
		ScrollAffordanceDivider = 0
	}

	if not useInternalScroll then
		scrollAffordanceDivider = nil
	end

	v7.ScrollAffordanceDivider = scrollAffordanceDivider
	return createElement(View, v6, v7)
end

return ScrollSection
