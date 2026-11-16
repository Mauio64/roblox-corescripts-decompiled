local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local view = Foundation.View

local function renderPanel(p2, hole, color, fn, fn2)
	local udim = if p2 == "Top" then UDim2.fromScale(1, 1) else UDim2.new()
	local createElement = React.createElement
	local v7

	if hole ~= nil then
		v7 = hole:map(function(p3)
			if p3 == nil then
				return (UDim2.new())
			end

			return (fn(p3))
		end)
	end

	local v8

	if hole == nil then
		v8 = udim
	else
		v8 = hole:map(function(p3)
			if p3 == nil then
				return udim
			end

			return (fn2(p3))
		end)
	end

	return createElement(view, {
		Position = v7,
		Size = v8,
		backgroundStyle = { Color3 = color, Transparency = 0 },
		testId = `Library.WorldBackdrop.{p2}`
	})
end

local function LibraryWorldBackdropView(props)
	local hole = props.hole
	local mapped = props.progress:map(function(value)
		return props.cornerRadius * (1 - math.clamp(value, 0, 1))
	end)

	local createElement = React.createElement
	local v6 = {
		Visible = props.Visible,
		ZIndex = props.ZIndex,
		GroupTransparency = props.transparency,
		tag = "size-full clip",
		testId = "Library.WorldBackdrop"
	}

	local v7 = {
		Top = renderPanel("Top", hole, props.color, function()
			return UDim2.new()
		end, function(p2)
			return UDim2.new(1, 0, 0, (math.max(0, p2.Min.Y)))
		end),
		Bottom = renderPanel("Bottom", hole, props.color, function(p2)
			return UDim2.fromOffset(0, p2.Max.Y)
		end, function(p2)
			return UDim2.new(1, 0, 1, (math.max(0, -p2.Max.Y)))
		end),
		Left = renderPanel("Left", hole, props.color, function(p2)
			return UDim2.fromOffset(0, p2.Min.Y)
		end, function(p2)
			return UDim2.fromOffset(math.max(0, p2.Min.X), (math.max(0, p2.Height)))
		end),
		Right = renderPanel("Right", hole, props.color, function(p2)
			return UDim2.fromOffset(p2.Max.X, p2.Min.Y)
		end, function(p2)
			return UDim2.new(1, math.max(0, -p2.Max.X), 0, (math.max(0, p2.Height)))
		end),
		Corners = 0
	}
	local v8

	if hole ~= nil then
		v8 = React.createElement(view, {
			Visible = hole:map(function(p2): boolean
				return p2 ~= nil
			end),
			Position = hole:map(function(p2)
				if p2 == nil then
					return (UDim2.new())
				end

				return (UDim2.fromOffset(p2.Min.X, p2.Min.Y))
			end),
			Size = hole:map(function(p2)
				if p2 == nil then
					return (UDim2.new())
				end

				return (UDim2.fromOffset(p2.Width, p2.Height))
			end),
			backgroundStyle = { Transparency = 1 },
			cornerRadius = mapped:map(function(p2)
				return UDim.new(0, p2)
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

	v7.Corners = v8
	return createElement(view, v6, v7)
end

return LibraryWorldBackdropView
