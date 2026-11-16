local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)

local extended = Roact.Component:extend("VirtualList")

function extended:init()
	self.scrollingRef = Roact.createRef()
	self.state = { canvasPosY = 0, absSizeY = 0 }

	function self.onScrollPropertyChanged()
		local current = self.scrollingRef.current

		if not current then
			return
		end

		local y = current.CanvasPosition.Y
		local y2 = current.AbsoluteSize.Y

		if y ~= self.state.canvasPosY or y2 ~= self.state.absSizeY then
			self:setState({ canvasPosY = y, absSizeY = y2 })
		end
	end
end

function extended:connectScrollListenersIfNeeded()
	local current = self.scrollingRef.current

	if current == self.connectedFrame then
		return
	end

	self:disconnectScrollListeners()

	if not current then
		return
	end

	self.connectedFrame = current
	self.canvasPosConnector = current:GetPropertyChangedSignal("CanvasPosition"):Connect(self.onScrollPropertyChanged)
	self.absSizeConnector = current:GetPropertyChangedSignal("AbsoluteSize"):Connect(self.onScrollPropertyChanged)
	self.onScrollPropertyChanged()
end

function extended:disconnectScrollListeners()
	if self.canvasPosConnector then
		self.canvasPosConnector:Disconnect()
		self.canvasPosConnector = nil
	end

	if self.absSizeConnector then
		self.absSizeConnector:Disconnect()
		self.absSizeConnector = nil
	end

	self.connectedFrame = nil
end

function extended:didMount()
	self:connectScrollListenersIfNeeded()
end

function extended:willUnmount()
	self:disconnectScrollListeners()
end

function extended:didUpdate(p)
	self:connectScrollListenersIfNeeded()

	local current = self.scrollingRef.current

	if not current then
		return
	end

	local y = current.AbsoluteSize.Y
	local y2 = current.CanvasPosition.Y

	if y ~= self.state.absSizeY or y2 ~= self.state.canvasPosY then
		self:setState({ absSizeY = y, canvasPosY = y2 })
	end

	local v = #(p.items or {})
	local count = #(self.props.items or {})

	if v == count then
		return
	end

	local canvasPosY = math.min(y2, (math.max(0, count * self.props.rowHeight - y)))

	if canvasPosY ~= current.CanvasPosition.Y then
		current.CanvasPosition = Vector2.new(current.CanvasPosition.X, canvasPosY)
	end

	if canvasPosY ~= self.state.canvasPosY then
		self:setState({ canvasPosY = canvasPosY })
	end
end

function extended.render(props)
	local items = props.props.items or {}
	local rowHeight = props.props.rowHeight
	local renderItem = props.props.renderItem
	local count = #items

	if count == 0 then
		return Roact.createElement("TextLabel", {
			Size = props.props.size or UDim2.new(1, 0, 1, 0),
			Position = props.props.position,
			LayoutOrder = props.props.layoutOrder,
			Text = props.props.emptyText or "",
			TextColor3 = Constants.Color.Text,
			TextTransparency = 0.5,
			BackgroundTransparency = 1
		})
	end

	local canvasPosY = props.state.canvasPosY
	local absSizeY = props.state.absSizeY

	local v = math.floor(canvasPosY / rowHeight) - 4 + 1
	local v2 = v + (math.ceil(absSizeY / rowHeight) + 8) - 1

	local children = {}

	for i = math.clamp(v, 1, count), math.clamp(v2, 1, count) do
		children["row" .. i] = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, rowHeight),
			Position = UDim2.new(0, 0, 0, (i - 1) * rowHeight),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}, { Item = renderItem(items[i], i) })
	end

	return Roact.createElement("ScrollingFrame", {
		Size = props.props.size or UDim2.new(1, 0, 1, 0),
		Position = props.props.position,
		LayoutOrder = props.props.layoutOrder,
		CanvasSize = UDim2.new(0, 0, 0, count * rowHeight),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 6,
		VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
		[Roact.Ref] = props.scrollingRef
	}, children)
end

return extended
