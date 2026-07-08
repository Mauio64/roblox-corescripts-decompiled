local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local v5 = Roact.PureComponent:extend("BarOnTopScrollingFrame")

v5.validateProps = t.strictInterface({
	Size = t.UDim2,
	Position = t.optional(t.UDim2),
	CanvasSize = t.UDim2,
	ScrollingEnabled = t.optional(t.boolean),
	[Roact.Children] = t.table,
	onCanvasPositionChanged = t.optional(t.callback),
	scrollingFrameRef = t.optional(t.table)
})
v5.defaultProps = {
	ScrollingEnabled = true
}

function v5.init(p1) -- line: 26
	p1.state = {
		CanvasPosition = Vector2.new(0, 0)
	}
end
function v5.render(p2) -- line: 32
	-- upvalues: Roact (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = p2.props.Size,
		Position = p2.props.Position
	}, {
		DisplayScrollingFrame = Roact.createElement("ScrollingFrame", {
			CanvasPosition = p2.state.CanvasPosition,
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 8, 1, 0),
			CanvasSize = p2.props.CanvasSize - UDim2.new(0, 8, 0, 0),
			ScrollBarThickness = 8,
			BorderSizePixel = 0,
			ZIndex = 2,
			Position = UDim2.new(1, -8, 0, 0),
			ScrollingEnabled = p2.props.ScrollingEnabled,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Selectable = false,
			[Roact.Ref] = p2.props.scrollingFrameRef,
			[Roact.Change.CanvasPosition] = function(p3) -- line: 52
				-- upvalues: p2 (copy)
				p2:setState({
					CanvasPosition = p3.CanvasPosition
				})

				if p2.props.onCanvasPositionChanged then
					p2.props.onCanvasPositionChanged(p3)
				end
			end
		}),
		ContentsScrollingFrame = Roact.createElement("ScrollingFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -8, 1, 0),
			CanvasSize = p2.props.CanvasSize - UDim2.new(0, 8, 0, 0),
			CanvasPosition = p2.state.CanvasPosition,
			ScrollBarThickness = 0,
			BorderSizePixel = 0,
			ClipsDescendants = false,
			ScrollingEnabled = p2.props.ScrollingEnabled,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Selectable = false,
			[Roact.Change.CanvasPosition] = function(p4) -- line: 73
				-- upvalues: p2 (copy)
				p2:setState({
					CanvasPosition = p4.CanvasPosition
				})
			end
		}, { Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 8, 1, 0)
		}, p2.props[Roact.Children]) })
	})
end

return v5
