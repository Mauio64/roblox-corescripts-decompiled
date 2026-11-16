local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local LineGraphHoverDisplay = require(script.Parent.LineGraphHoverDisplay)

local Constants = require(script.Parent.Parent.Constants)
local Text = Constants.Color.Text
local HighlightBlue = Constants.Color.HighlightBlue
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor

local PointWidth = Constants.Graph.PointWidth
local PointOffset = Constants.Graph.PointOffset
local Padding = Constants.Graph.Padding
local Scale = Constants.Graph.Scale
local InnerPaddingY = Constants.Graph.InnerPaddingY
local InnerScaleY = Constants.Graph.InnerScaleY
local TextPadding = Constants.Graph.TextPadding

local extended = Roact.Component:extend("LineGraph")

function extended:init()
	function self.onGraphInputChanged(_, p)
		if p.UserInputType == Enum.UserInputType.MouseMovement and not self.state.holdPos then
			self:setState({ inputPosition = p.Position })
		end
	end

	function self.onGraphInputEnded(_, p)
		if p.UserInputType == Enum.UserInputType.MouseMovement then
			if not self.state.holdPos then
				self:setState({ inputPosition = false })
			end
		elseif p.UserInputType == Enum.UserInputType.MouseButton1 then
			self:setState({
				holdPos = not self.state.holdPos
			})
		end
	end

	self.graphRef = Roact.createRef()
	self.state = { selectedTimeStamps = {} }
end

function extended.didUpdate(object)
	if object.state.absGraphSize ~= object.graphRef.current.AbsoluteSize then
		object:setState({
			absGraphSize = object.graphRef.current.AbsoluteSize,
			absGraphPos = object.graphRef.current.AbsolutePosition
		})
	end
end

function extended.didMount(object)
	object:setState({
		absGraphSize = object.graphRef.current.AbsoluteSize,
		absGraphPos = object.graphRef.current.AbsolutePosition
	})
end

function extended.render(props)
	local size = props.props.size
	local pos = props.props.pos

	local graphData = props.props.graphData

	local getX = props.props.getX
	local getY = props.props.getY

	local stringFormatX = props.props.stringFormatX
	local stringFormatY = props.props.stringFormatY

	local axisLabelX = props.props.axisLabelX
	local axisLabelY = props.props.axisLabelY

	local layoutOrder = props.props.layoutOrder

	local inputPosition = props.state.inputPosition
	local absGraphSize = props.state.absGraphSize
	local absGraphPos = props.state.absGraphPos

	local text = getX(graphData:back())
	local text2 = getX(graphData:front())
	local maxY = props.props.maxY
	local text3 = props.props.minY

	local hoverLineY = nil

	local children = {}

	if absGraphSize then
		local iterator = graphData:iterator()
		local v = iterator:next()
		local v2 = {}

		while v do
			local y = getY(v)
			local x = getX(v)

			local v3 = text - text2
			local v4 = v3 > 0 and (x - text2) / v3 or 0

			local v5 = maxY - text3
			table.insert(v2, {
				X = v4,
				Y = v5 > 0 and (y - text3) / v5 or 1,
				data = v
			})

			v = iterator:next()
		end

		for i = 2, #v2 do
			local v3 = v2[i].X * absGraphSize.X
			local v4 = v2[i].Y * absGraphSize.Y * InnerScaleY
			local v5 = v2[i - 1].X * absGraphSize.X
			local v6 = v2[i - 1].Y * absGraphSize.Y * InnerScaleY

			if v3 == v5 then
				continue
			end

			local midpoint = (v3 + v5) / 2
			local midpoint2 = (v4 + v6) / 2

			local v7 = v3 - v5
			local v8 = v4 - v6

			local v9 = math.sqrt(v7 * v7 + v8 * v8)
			local v10 = math.deg((math.atan2(v8, v7)))

			table.insert(children, Roact.createElement("Frame", {
				Size = UDim2.new(0, v9, 0, LineWidth),
				Position = UDim2.new(0, midpoint - v9 / 2, 1 - InnerPaddingY, -midpoint2),
				BackgroundColor3 = HighlightBlue,
				BorderSizePixel = 0,
				Rotation = -v10
			}))

			table.insert(children, Roact.createElement("Frame", {
				Size = UDim2.new(0, PointWidth, 0, PointWidth),
				Position = UDim2.new(0, v3, 1 - InnerPaddingY, -v4 - PointOffset),
				BackgroundColor3 = HighlightBlue,
				BorderSizePixel = 0
			}))

			if not inputPosition then
				continue
			end

			local hoverLineX = inputPosition.X - absGraphPos.X

			if not (hoverLineX < v3 and v5 < hoverLineX) then
				continue
			end

			local x = getX(v2[i].data)
			local x2 = getX(v2[i - 1].data)
			local y = getY(v2[i].data)
			local y2 = getY(v2[i - 1].data)

			local v11 = (hoverLineX - v5) / v7
			hoverLineY = v6 + v8 * v11

			local hoverValX = (x - x2) * v11 + x2
			local hoverValY = (y - y2) * v11 + y2

			children.HoverDetails = Roact.createElement(LineGraphHoverDisplay, {
				hoverLineX = hoverLineX,
				hoverLineY = hoverLineY,
				hoverValX = hoverValX,
				hoverValY = hoverValY,
				stringFormatX = stringFormatX,
				stringFormatY = stringFormatY
			})
		end

		if #v2 > 0 then
			local v3 = v2[#v2].Y * absGraphSize.Y * InnerScaleY
			local text4 = getY(v2[#v2].data)

			local v4 = not (hoverLineY and math.abs(v3 - hoverLineY) < 10)

			local v5 = not (hoverLineY and math.abs(hoverLineY) < 10 or math.abs(v3) < 10)

			if v4 then
				children.LatestEntryLine = Roact.createElement("Frame", {
					Size = UDim2.new(1, TextPadding, 0, LineWidth),
					Position = UDim2.new(0, -TextPadding, 1 - InnerPaddingY, -v3),
					BackgroundColor3 = LineColor,
					BackgroundTransparency = 0.5,
					BorderSizePixel = 0
				})

				local createElement = Roact.createElement
				text4 = stringFormatY and stringFormatY(text4) or text4
				children.LatestEntryText = createElement("TextLabel", {
					Text = text4,
					TextColor3 = Text,
					TextXAlignment = Enum.TextXAlignment.Right,
					Position = UDim2.new(0, -TextPadding - 2, 1 - InnerPaddingY, -v3),
					BackgroundTransparency = 1
				})
			end

			if v5 then
				local createElement = Roact.createElement
				text3 = stringFormatY and stringFormatY(text3) or text3
				children.AxisTextY0 = createElement("TextLabel", {
					Text = text3,
					TextColor3 = Text,
					TextXAlignment = Enum.TextXAlignment.Right,
					Position = UDim2.new(0, -TextPadding - 2, 1 - InnerPaddingY, 0),
					BackgroundTransparency = 1
				})
			end

			children.AxisX = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, LineWidth),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = LineColor,
				BorderSizePixel = 0
			})

			children.AxisY = Roact.createElement("Frame", {
				Size = UDim2.new(0, LineWidth, 1, 0),
				BackgroundColor3 = LineColor,
				BorderSizePixel = 0
			})
		end
	end

	local v = 2 * TextPadding + 2

	local createElement = Roact.createElement

	local children2 = {
		name = Roact.createElement("TextLabel", {
			Text = axisLabelY,
			TextColor3 = Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Position = UDim2.new(Padding, 0, Padding, -TextPadding),
			BackgroundTransparency = 1
		}),
		minX = 0,
		maxX = 0,
		axisLabelX = 0,
		graph = 0
	}

	local createElement2 = Roact.createElement
	text2 = stringFormatX and stringFormatX(text2) or text2
	children2.minX = createElement2("TextLabel", {
		Text = text2,
		TextColor3 = Text,
		TextXAlignment = Enum.TextXAlignment.Center,
		Position = UDim2.new(Padding, 0, Padding + Scale, v),
		BackgroundTransparency = 1
	})

	local createElement3 = Roact.createElement
	text = stringFormatX and stringFormatX(text) or text
	children2.maxX = createElement3("TextLabel", {
		Text = text,
		TextColor3 = Text,
		TextXAlignment = Enum.TextXAlignment.Center,
		Position = UDim2.new(Padding + Scale, 0, Padding + Scale, v),
		BackgroundTransparency = 1
	})

	children2.axisLabelX = Roact.createElement("TextLabel", {
		Text = axisLabelX,
		TextColor3 = Text,
		TextXAlignment = Enum.TextXAlignment.Center,
		Position = UDim2.new(0.5, 0, Padding + Scale, v),
		BackgroundTransparency = 1
	})

	children2.graph = Roact.createElement("Frame", {
		Position = UDim2.new(Padding, 0, Padding, 0),
		Size = UDim2.new(Scale, 0, Scale, 0),
		BackgroundTransparency = 1,
		[Roact.Ref] = props.graphRef,
		[Roact.Event.InputChanged] = props.onGraphInputChanged,
		[Roact.Event.InputEnded] = props.onGraphInputEnded
	}, children)
	return createElement(
		"Frame",
		{ Size = size, Position = pos, BackgroundTransparency = 1, LayoutOrder = layoutOrder },
		children2
	)
end

return extended
