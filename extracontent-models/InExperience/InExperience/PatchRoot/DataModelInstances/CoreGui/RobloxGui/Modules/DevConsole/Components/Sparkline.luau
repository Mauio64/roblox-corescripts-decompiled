local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Constants)
local LineWidth = Constants.GeneralFormatting.LineWidth
local HighlightBlue = Constants.Color.HighlightBlue
local udim = UDim2.fromOffset(52, 13)

local extended = Roact.Component:extend("Sparkline")

function extended:init()
	self.graphRef = Roact.createRef()
	self.state = { absSize = nil }
end

function extended.didMount(object)
	object:setState({ absSize = object.graphRef.current.AbsoluteSize })
end

function extended.didUpdate(object)
	local absoluteSize = object.graphRef.current.AbsoluteSize

	if object.state.absSize ~= absoluteSize then
		object:setState({ absSize = absoluteSize })
	end
end

function extended.render(props)
	local dataSet = props.props.dataSet
	local getY = props.props.getY
	local minY = props.props.minY
	local maxY = props.props.maxY
	local color = props.props.color or HighlightBlue
	local absSize = props.state.absSize

	local children = {}

	if absSize and dataSet then
		local iterator = dataSet:iterator()
		local v = iterator:next()
		local v2 = {}

		while v do
			table.insert(v2, getY(v))
			v = iterator:next()
		end

		local v3 = maxY - minY
		local count = #v2

		for i = 2, count do
			local v4 = v3 > 0 and (v2[i] - minY) / v3 or 0.5
			local v5 = v3 > 0 and (v2[i - 1] - minY) / v3 or 0.5

			local v6 = (i - 1) / (count - 1) * absSize.X
			local v7 = (i - 2) / (count - 1) * absSize.X
			local v8 = v4 * absSize.Y
			local v9 = v5 * absSize.Y

			local midpoint = (v6 + v7) / 2
			local midpoint2 = (v8 + v9) / 2
			local v10 = v6 - v7
			local v11 = v8 - v9

			local v12 = math.sqrt(v10 * v10 + v11 * v11)
			local v13 = math.deg((math.atan2(v11, v10)))

			children["seg" .. i] = Roact.createElement("Frame", {
				Size = UDim2.new(0, v12, 0, LineWidth),
				Position = UDim2.new(0, midpoint - v12 / 2, 1, -midpoint2),
				BackgroundColor3 = color,
				BorderSizePixel = 0,
				Rotation = -v13
			})
		end
	end

	return Roact.createElement("Frame", {
		Size = props.props.size or udim,
		Position = props.props.pos,
		LayoutOrder = props.props.layoutOrder,
		BackgroundTransparency = 1,
		[Roact.Ref] = props.graphRef
	}, children)
end

return extended
