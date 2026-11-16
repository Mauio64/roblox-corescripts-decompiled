local AppPageShell = script:FindFirstAncestor("AppPageShell")
local parent = AppPageShell.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Responsive = require(parent.Responsive)

require(AppPageShell.PageTypes)
local computeStickyOffset = require(AppPageShell.computeStickyOffset)

local View = Foundation.View
local useDeviceInsets = Responsive.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiFeedScrollBarFixes = SharedFlags.FFlagSduiFeedScrollBarFixes

local function PageStickyHeader(props)
	local topPadding = props.topPadding
	local backgroundStyle = props.backgroundStyle
	local slots = props.slots
	local chromeHeight = props.chromeHeight or 0
	local liveChromeHeightBinding = props.liveChromeHeightBinding

	local v = useTokens()
	local v2, v3 = React.useBinding(0)
	local position

	if not FFlagSduiFeedScrollBarFixes then
		local top = useDeviceInsets().top

		position = React.useMemo(function()
			if liveChromeHeightBinding == nil or chromeHeight <= 0 then
				return UDim2.fromOffset(0, 0)
			end

			return liveChromeHeightBinding:map(function(p: number)
				return UDim2.fromOffset(0, computeStickyOffset(p, chromeHeight, top))
			end)
		end, { liveChromeHeightBinding, chromeHeight, top })
	end

	local size = React.useMemo(function()
		return v2:map(function(p: number)
			return UDim2.new(1, 0, 0, p + chromeHeight)
		end)
	end, { v2, chromeHeight })

	local v4 = React.useMemo(function()
		if slots == nil or next(slots) == nil then
			return nil
		end

		local slots2 = {}

		for k, slot in slots do
			slots2[`Sticky{k}`] = slot
		end

		return slots2
	end, { slots })

	local size2 = React.useMemo(function()
		return v2:map(function(p: number)
			return UDim2.new(1, 0, 0, p)
		end)
	end, { v2 })

	local v5 = React.useCallback(function(p)
		v3(p.AbsoluteSize.Y)
	end, {})

	if v4 == nil then
		return nil
	end

	local createElement = React.createElement

	local createElement2 = React.createElement

	if FFlagSduiFeedScrollBarFixes then
		position = nil
	end

	local v6 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = position,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ClipsDescendants = false,
		[React.Change.AbsoluteSize] = v5
	}

	local createElement3 = React.createElement
	local v7 = {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = size,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 0
	}
	local backgroundColor

	if backgroundStyle then
		backgroundColor = backgroundStyle.Color3
	else
		backgroundColor = v.Color.Surface.Surface_0.Color3
	end

	v7.BackgroundColor3 = backgroundColor

	v7.BackgroundTransparency = (not backgroundStyle or backgroundStyle.Transparency == nil) and 0
		or backgroundStyle.Transparency
	local children = { Background = createElement3("Frame", v7), Content = 0 }

	local createElement4 = React.createElement
	local v8 = {
		tag = `col size-full-0 auto-y {props.tag or ""}`
	}
	local topSpacer

	if topPadding and topPadding > 0 then
		topSpacer = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, topPadding),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1
		})
	end

	children.Content = createElement4(View, v8, {
		TopSpacer = topSpacer,
		Body = React.createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = 2 }, v4)
	})
	return createElement(View, {
		Size = size2,
		LayoutOrder = 1,
		ZIndex = 2,
		ClipsDescendants = false
	}, {
		Translation = createElement2("Frame", v6, children)
	})
end

return React.memo(PageStickyHeader)
