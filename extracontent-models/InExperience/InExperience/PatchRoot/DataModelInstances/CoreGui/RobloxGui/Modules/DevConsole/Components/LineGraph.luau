local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local LineGraphHoverDisplay = require(script.Parent.LineGraphHoverDisplay)
local Constants = require(script.Parent.Parent.Constants)
local ColorText = Constants.Color.Text
local HighlightBlue = Constants.Color.HighlightBlue
local LineWidth = Constants.GeneralFormatting.LineWidth
local LineColor = Constants.GeneralFormatting.LineColor
local PointWidth = Constants.Graph.PointWidth
local PointOffset = Constants.Graph.PointOffset
local GraphPadding = Constants.Graph.Padding
local GraphScale = Constants.Graph.Scale
local InnerPaddingY = Constants.Graph.InnerPaddingY
local InnerScaleY = Constants.Graph.InnerScaleY
local TextPadding = Constants.Graph.TextPadding
local v16 = Roact.Component:extend("LineGraph")

function v16.init(p1) -- line: 24
	-- upvalues: Roact (copy)
	function p1.onGraphInputChanged(_, p3) -- line: 25
		-- upvalues: p1 (copy)
		if p3.UserInputType == Enum.UserInputType.MouseMovement and not p1.state.holdPos then
			p1:setState({
				inputPosition = p3.Position
			})
		end
	end
	function p1.onGraphInputEnded(_, p5) -- line: 35
		-- upvalues: p1 (copy)
		if p5.UserInputType == Enum.UserInputType.MouseMovement then
			if not p1.state.holdPos then
				p1:setState({
					inputPosition = false
				})

				return
			end
		elseif p5.UserInputType == Enum.UserInputType.MouseButton1 then
			p1:setState({
				holdPos = not p1.state.holdPos
			})
		end
	end

	p1.graphRef = Roact.createRef()
	p1.state = {
		selectedTimeStamps = {}
	}
end
function v16.didUpdate(p6) -- line: 55
	if p6.state.absGraphSize ~= p6.graphRef.current.AbsoluteSize then
		local AbsoluteSize = p6.graphRef.current.AbsoluteSize
		local AbsolutePosition = p6.graphRef.current.AbsolutePosition

		p6:setState({
			absGraphSize = AbsoluteSize,
			absGraphPos = AbsolutePosition
		})
	end
end
function v16.didMount(p7) -- line: 67
	local AbsoluteSize = p7.graphRef.current.AbsoluteSize
	local AbsolutePosition = p7.graphRef.current.AbsolutePosition

	p7:setState({
		absGraphSize = AbsoluteSize,
		absGraphPos = AbsolutePosition
	})
end
function v16.render(p8) -- line: 77
	-- upvalues: InnerScaleY (copy), Roact (copy), LineWidth (copy), InnerPaddingY (copy), HighlightBlue (copy), PointWidth (copy), PointOffset (copy), LineGraphHoverDisplay (copy), TextPadding (copy), LineColor (copy), ColorText (copy), GraphPadding (copy), GraphScale (copy)
	local size = p8.props.size
	local pos = p8.props.pos
	local graphData = p8.props.graphData
	local getX = p8.props.getX
	local getY = p8.props.getY
	local stringFormatX = p8.props.stringFormatX
	local stringFormatY = p8.props.stringFormatY
	local axisLabelX = p8.props.axisLabelX
	local axisLabelY = p8.props.axisLabelY
	local layoutOrder = p8.props.layoutOrder
	local inputPosition = p8.state.inputPosition
	local absGraphSize = p8.state.absGraphSize
	local absGraphPos = p8.state.absGraphPos
	local v38 = getX(graphData:back())
	local v39 = getX(graphData:front())
	local maxY = p8.props.maxY
	local minY = p8.props.minY
	local v42 = nil
	local t1 = {}

	if absGraphSize then
		local t2 = {}
		local v45 = graphData:iterator()
		local v46 = v45:next()

		while v46 do
			local v47 = getY(v46)
			local v48 = getX(v46)
			local v49 = v38 - v39
			local v50 = v49 > 0 and (v48 - v39) / v49 or 0
			local v51 = maxY - minY
			local v52 = v51 > 0 and (v47 - minY) / v51 or 1

			table.insert(t2, {
				X = v50,
				Y = v52,
				data = v46
			})
			v46 = v45:next()
		end

		for i = 2, #t2 do
			local v54 = t2[i].X * absGraphSize.X
			local v55 = t2[i].Y * absGraphSize.Y * InnerScaleY
			local v56 = t2[i - 1].X * absGraphSize.X
			local v57 = t2[i - 1].Y * absGraphSize.Y * InnerScaleY

			if v54 ~= v56 then
				local v58 = (v54 + v56) / 2
				local v59 = (v55 + v57) / 2
				local v60 = v54 - v56
				local v61 = v55 - v57
				local v62 = math.sqrt(v60 * v60 + v61 * v61)
				local v63 = math.deg((math.atan2(v61, v60)))

				table.insert(t1, Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(0, v62, 0, LineWidth),
					Position = UDim2.new(0, v58 - v62 / 2, 1 - InnerPaddingY, -v59),
					BackgroundColor3 = HighlightBlue,
					Rotation = -v63
				}))
				table.insert(t1, Roact.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(0, PointWidth, 0, PointWidth),
					Position = UDim2.new(0, v54, 1 - InnerPaddingY, -v55 - PointOffset),
					BackgroundColor3 = HighlightBlue
				}))

				if inputPosition then
					local v64 = inputPosition.X - absGraphPos.X

					if v64 < v54 and v56 < v64 then
						local v65 = getX(t2[i].data)
						local v66 = getX(t2[i - 1].data)
						local v67 = getY(t2[i].data)
						local v68 = getY(t2[i - 1].data)
						local v69 = (v64 - v56) / v60

						v42 = v57 + v61 * v69

						local v70 = (v65 - v66) * v69 + v66
						local v71 = (v67 - v68) * v69 + v68

						t1.HoverDetails = Roact.createElement(LineGraphHoverDisplay, {
							hoverLineX = v64,
							hoverLineY = v42,
							hoverValX = v70,
							hoverValY = v71,
							stringFormatX = stringFormatX,
							stringFormatY = stringFormatY
						})
					end
				end
			end
		end

		if #t2 > 0 then
			local v72 = t2[#t2].Y * absGraphSize.Y * InnerScaleY
			local v73 = getY(t2[#t2].data)
			local v74 = v42 and math.abs(v72 - v42) < 10
			local v75 = v42 and math.abs(v42) < 10 or math.abs(v72) < 10

			if not v74 then
				t1.LatestEntryLine = Roact.createElement("Frame", {
					BackgroundTransparency = 0.5,
					BorderSizePixel = 0,
					Size = UDim2.new(1, TextPadding, 0, LineWidth),
					Position = UDim2.new(0, -TextPadding, 1 - InnerPaddingY, -v72),
					BackgroundColor3 = LineColor
				})
				t1.LatestEntryText = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = stringFormatY and stringFormatY(v73) or v73,
					TextColor3 = ColorText,
					TextXAlignment = Enum.TextXAlignment.Right,
					Position = UDim2.new(0, -TextPadding - 2, 1 - InnerPaddingY, -v72)
				})
			end

			if not v75 then
				t1.AxisTextY0 = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = stringFormatY and stringFormatY(minY) or minY,
					TextColor3 = ColorText,
					TextXAlignment = Enum.TextXAlignment.Right,
					Position = UDim2.new(0, -TextPadding - 2, 1 - InnerPaddingY, 0)
				})
			end

			t1.AxisX = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, LineWidth),
				Position = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = LineColor
			})
			t1.AxisY = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(0, LineWidth, 1, 0),
				BackgroundColor3 = LineColor
			})
		end
	end

	local v76 = 2 * TextPadding + 2

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size,
		Position = pos,
		LayoutOrder = layoutOrder
	}, {
		name = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = axisLabelY,
			TextColor3 = ColorText,
			TextXAlignment = Enum.TextXAlignment.Left,
			Position = UDim2.new(GraphPadding, 0, GraphPadding, -TextPadding)
		}),
		minX = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = stringFormatX and stringFormatX(v39) or v39,
			TextColor3 = ColorText,
			TextXAlignment = Enum.TextXAlignment.Center,
			Position = UDim2.new(GraphPadding, 0, GraphPadding + GraphScale, v76)
		}),
		maxX = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = stringFormatX and stringFormatX(v38) or v38,
			TextColor3 = ColorText,
			TextXAlignment = Enum.TextXAlignment.Center,
			Position = UDim2.new(GraphPadding + GraphScale, 0, GraphPadding + GraphScale, v76)
		}),
		axisLabelX = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = axisLabelX,
			TextColor3 = ColorText,
			TextXAlignment = Enum.TextXAlignment.Center,
			Position = UDim2.new(0.5, 0, GraphPadding + GraphScale, v76)
		}),
		graph = Roact.createElement("Frame", {
			Position = UDim2.new(GraphPadding, 0, GraphPadding, 0),
			Size = UDim2.new(GraphScale, 0, GraphScale, 0),
			BackgroundTransparency = 1,
			[Roact.Ref] = p8.graphRef,
			[Roact.Event.InputChanged] = p8.onGraphInputChanged,
			[Roact.Event.InputEnded] = p8.onGraphInputEnded
		}, t1)
	})
end

return v16
