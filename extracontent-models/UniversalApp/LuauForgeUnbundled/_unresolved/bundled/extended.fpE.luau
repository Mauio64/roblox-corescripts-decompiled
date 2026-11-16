local module = require("@luauforge/bundled/ecR")
local module2 = require("@luauforge/bundled/dww")
local module3 = require("@luauforge/bundled/fpF")

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")

local extended = module.PureComponent:extend("FitTextLabel")

extended.defaultProps = { fitAxis = FitChildren.FitAxis.Height, maxWidth = nil }

function extended:init()
	function self.onRef(ref)
		self.ref = ref
	end

	function self.resize(data)
		local fitAxis = self.props.fitAxis
		local maxWidth = self.props.maxWidth

		if fitAxis == FitChildren.FitAxis.Width or fitAxis == FitChildren.FitAxis.Both then
			local udim = UDim.new(0, module3.GetTextWidth(data.Text, data.Font, data.TextSize))
			local udim2

			if maxWidth == nil or not (maxWidth < udim.Offset) then
				udim2 = fitAxis == FitChildren.FitAxis.Both and UDim.new(0, data.TextSize) or data.Size.Height
			else
				udim = UDim.new(0, maxWidth)
				udim2 = UDim.new(0, module3.GetTextHeight(data.Text, data.Font, data.TextSize, udim.Offset))
			end

			self:setState({ width = udim, height = udim2 })
		else
			local udim = UDim.new(
				0,
				module3.GetTextHeight(data.Text, data.Font, data.TextSize, data.AbsoluteSize.X)
			)

			self:setState({ width = data.Size.Width, height = udim })
		end
	end

	self:setState({ width = nil, height = nil })
end

function extended.render(props)
	local fitAxis = props.props.fitAxis or FitChildren.FitAxis.Height
	local v5 = module2.RemoveFromDictionary(props.props, "fitAxis", "maxWidth")
	local width = props.state.width
	local height = props.state.height

	if width and height then
		v5 = module2.JoinDictionaries(v5, { Size = UDim2.new(width, height) })
	end

	return module.createElement("TextLabel", module2.JoinDictionaries(v5, {
		[module.Ref] = props.onRef,
		[module.Change.Text] = props.resize,
		[module.Change.TextSize] = props.resize,
		[module.Change.AbsoluteSize] = fitAxis == FitChildren.FitAxis.Height and props.resize or nil
	}))
end

function extended.didMount(p2)
	p2.resize(p2.ref)
end

return extended
