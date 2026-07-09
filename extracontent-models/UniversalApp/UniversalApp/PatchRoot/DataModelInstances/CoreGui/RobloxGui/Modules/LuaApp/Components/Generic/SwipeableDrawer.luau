local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local FitChildren = require(Modules.LuaApp.FitChildren)
local v5 = Roact.PureComponent:extend("SwipeableDrawer")

function v5.init(p1) -- line: 28
	-- upvalues: Roact (copy)
	p1.frameRef = nil

	function p1.onFrameRef(p2) -- line: 30
		-- upvalues: p1 (copy)
		if p2 then
			local startPosition = p1.props.startPosition

			p1.frameRef = p2
			p1.frameRef.Position = UDim2.new(0, 0, 0, startPosition)
		end
	end

	p1.scrollingFrameRef = Roact.createRef()

	function p1.recalculateDrawerPosition() -- line: 41
		-- upvalues: p1 (copy)
		if p1.frameRef and p1.scrollingFrameRef.current then
			local startPosition = p1.props.startPosition
			local YOffset = p1.scrollingFrameRef.current.CanvasSize.Y.Offset
			local v17 = math.max(0, p1.props.containerHeight - YOffset)
			local YOffset2 = p1.frameRef.Position.Y.Offset
			local CanvasPositionY = p1.scrollingFrameRef.current.CanvasPosition.Y

			if YOffset2 == v17 and CanvasPositionY > 0 or YOffset2 == startPosition and CanvasPositionY < 0 then
				return
			end

			local v20 = math.min(math.max(YOffset2 - CanvasPositionY, v17), startPosition)

			p1.frameRef.Position = UDim2.new(0, 0, 0, v20)
			p1.scrollingFrameRef.current.CanvasPosition = Vector2.new(0, 0)
		end
	end
end
function v5.render(p3) -- line: 69
	-- upvalues: Roact (copy), FitChildren (copy)
	local propsSize = p3.props.Size
	local propsAnchorPoint = p3.props.AnchorPoint
	local v10 = p3.props[Roact.Children]

	return Roact.createElement("Frame", {
		Size = propsSize,
		AnchorPoint = propsAnchorPoint,
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		[Roact.Ref] = p3.onFrameRef
	}, {
		ScrollingFrame = Roact.createElement(FitChildren.FitScrollingFrame, {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			ClipsDescendants = false,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			fitFields = {
				CanvasSize = FitChildren.FitAxis.Height
			},
			[Roact.Ref] = p3.scrollingFrameRef,
			[Roact.Change.CanvasSize] = p3.recalculateDrawerPosition,
			[Roact.Change.CanvasPosition] = p3.recalculateDrawerPosition
		}, v10)
	})
end
function v5.didUpdate(p4, p5) -- line: 99
	if p5.startPosition ~= p4.props.startPosition or p5.containerHeight ~= p4.props.containerHeight then
		p4.recalculateDrawerPosition()
	end
end

return v5
