local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)

local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local extended = Roact.PureComponent:extend("BarOnTopScrollingFrame")

extended.validateProps = t.strictInterface({
	Size = t.UDim2,
	Position = t.optional(t.UDim2),
	CanvasSize = t.UDim2,
	ScrollingEnabled = t.optional(t.boolean),
	[Roact.Children] = t.table,
	onCanvasPositionChanged = t.optional(t.callback),
	scrollingFrameRef = t.optional(t.table)
})

extended.defaultProps = { ScrollingEnabled = true }

function extended:init()
	self.state = { CanvasPosition = Vector2.new(0, 0) }
end

function extended.render(object)
	return Roact.createElement(
		"Frame",
		{
			Size = object.props.Size,
			Position = object.props.Position,
			BackgroundTransparency = 1,
			ClipsDescendants = true
		},
		{
			DisplayScrollingFrame = Roact.createElement("ScrollingFrame", {
				CanvasPosition = object.state.CanvasPosition,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 8, 1, 0),
				CanvasSize = object.props.CanvasSize - UDim2.new(0, 8, 0, 0),
				ScrollBarThickness = 8,
				BorderSizePixel = 0,
				ZIndex = 2,
				Position = UDim2.new(1, -8, 0, 0),
				ScrollingEnabled = object.props.ScrollingEnabled,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Selectable = false,
				[Roact.Ref] = object.props.scrollingFrameRef,
				[Roact.Change.CanvasPosition] = function(p)
					object:setState({ CanvasPosition = p.CanvasPosition })

					if object.props.onCanvasPositionChanged then
						object.props.onCanvasPositionChanged(p)
					end
				end
			}),
			ContentsScrollingFrame = Roact.createElement("ScrollingFrame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -8, 1, 0),
				CanvasSize = object.props.CanvasSize - UDim2.new(0, 8, 0, 0),
				CanvasPosition = object.state.CanvasPosition,
				ScrollBarThickness = 0,
				BorderSizePixel = 0,
				ClipsDescendants = false,
				ScrollingEnabled = object.props.ScrollingEnabled,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				Selectable = false,
				[Roact.Change.CanvasPosition] = function(p)
					object:setState({ CanvasPosition = p.CanvasPosition })
				end
			}, { Roact.createElement(
					"Frame",
					{ BackgroundTransparency = 1, Size = UDim2.new(1, 8, 1, 0) },
					object.props[Roact.Children]
				) })
		}
	)
end

return extended
