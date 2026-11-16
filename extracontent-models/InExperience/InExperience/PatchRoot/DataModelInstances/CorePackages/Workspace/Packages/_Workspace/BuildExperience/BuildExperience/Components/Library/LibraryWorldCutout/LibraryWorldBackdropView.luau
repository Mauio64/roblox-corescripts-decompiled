local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local function renderPanel(p: string, hole, color: Color3, fn, fn2)
	local udim

	if p == "Top" then
		udim = UDim2.fromScale(1, 1)
	else
		udim = UDim2.new()
	end

	local createElement = React.createElement
	local position

	if hole ~= nil then
		position = hole:map(function(rect: Rect?)
			if rect == nil then
				return (UDim2.new())
			end

			return (fn(rect))
		end)
	end

	local size

	if hole == nil then
		size = udim
	else
		size = hole:map(function(rect: Rect?)
			if rect == nil then
				return udim
			end

			return (fn2(rect))
		end)
	end

	return createElement(View, {
		Position = position,
		Size = size,
		backgroundStyle = { Color3 = color, Transparency = 0 },
		testId = `Library.WorldBackdrop.{p}`
	})
end

local function LibraryWorldBackdropView(props)
	local hole = props.hole
	local mapped = props.progress:map(function(value: number)
		return props.cornerRadius * (1 - math.clamp(value, 0, 1))
	end)

	local createElement = React.createElement
	local v = {
		Visible = props.Visible,
		ZIndex = props.ZIndex,
		GroupTransparency = props.transparency,
		tag = "size-full clip",
		testId = "Library.WorldBackdrop"
	}

	local v2 = {
		Top = renderPanel("Top", hole, props.color, function()
			return UDim2.new()
		end, function(p)
			return UDim2.new(1, 0, 0, (math.max(0, p.Min.Y)))
		end),
		Bottom = renderPanel("Bottom", hole, props.color, function(p)
			return UDim2.fromOffset(0, p.Max.Y)
		end, function(p)
			return UDim2.new(1, 0, 1, (math.max(0, -p.Max.Y)))
		end),
		Left = renderPanel("Left", hole, props.color, function(p)
			return UDim2.fromOffset(0, p.Min.Y)
		end, function(p)
			return UDim2.fromOffset(math.max(0, p.Min.X), (math.max(0, p.Height)))
		end),
		Right = renderPanel("Right", hole, props.color, function(p)
			return UDim2.fromOffset(p.Max.X, p.Min.Y)
		end, function(p)
			return UDim2.new(1, math.max(0, -p.Max.X), 0, (math.max(0, p.Height)))
		end),
		Corners = 0
	}
	local corners

	if hole ~= nil then
		corners = React.createElement(View, {
			Visible = hole:map(function(rect: Rect?): boolean
				return rect ~= nil
			end),
			Position = hole:map(function(rect: Rect?)
				if rect == nil then
					return (UDim2.new())
				end

				return (UDim2.fromOffset(rect.Min.X, rect.Min.Y))
			end),
			Size = hole:map(function(rect: Rect?)
				if rect == nil then
					return (UDim2.new())
				end

				return (UDim2.fromOffset(rect.Width, rect.Height))
			end),
			backgroundStyle = { Transparency = 1 },
			cornerRadius = mapped:map(function(p: number)
				return UDim.new(0, p)
			end),
			stroke = {
				Color = props.color,
				Thickness = mapped,
				Transparency = 0,
				BorderStrokePosition = Enum.BorderStrokePosition.Outer
			},
			testId = "Library.WorldBackdrop.Corners"
		})
	end

	v2.Corners = corners
	return createElement(View, v, v2)
end

return LibraryWorldBackdropView
