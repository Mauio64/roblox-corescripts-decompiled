local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Roact = require(AuthCommonParent.Roact)
local Immutable = require(AuthCommonParent.AppCommonLib).Immutable
local Text = require(AuthCommonParent.AppCommonLib).Text
local FitChildren = require(AuthCommon.Components.FitChildren)
local v7 = Roact.PureComponent:extend("FitTextLabel")

v7.defaultProps = {
	maxWidth = nil,
	fitAxis = FitChildren.FitAxis.Height
}

function v7.init(p1) -- line: 17
	-- upvalues: FitChildren (copy), Text (copy)
	function p1.onRef(p2) -- line: 18
		-- upvalues: p1 (copy)
		p1.ref = p2
	end
	function p1.resize(p3) -- line: 22
		-- upvalues: p1 (copy), FitChildren (copy), Text (copy)
		local fitAxis = p1.props.fitAxis
		local maxWidth = p1.props.maxWidth

		if fitAxis == FitChildren.FitAxis.Width or fitAxis == FitChildren.FitAxis.Both then
			local uDim = UDim.new(0, Text.GetTextWidth(p3.Text, p3.Font, p3.TextSize))
			local uDim2

			if maxWidth ~= nil and maxWidth < uDim.Offset then
				uDim = UDim.new(0, maxWidth)
				uDim2 = UDim.new(0, Text.GetTextHeight(p3.Text, p3.Font, p3.TextSize, uDim.Offset))
			else
				uDim2 = fitAxis == FitChildren.FitAxis.Both and UDim.new(0, p3.TextSize) or p3.Size.Height
			end

			p1:setState({
				width = uDim,
				height = uDim2
			})

			return
		end

		local uDim = UDim.new(0, Text.GetTextHeight(p3.Text, p3.Font, p3.TextSize, p3.AbsoluteSize.X))

		p1:setState({
			width = p3.Size.Width,
			height = uDim
		})
	end

	p1:setState({
		width = nil,
		height = nil
	})
end
function v7.render(p4) -- line: 62
	-- upvalues: FitChildren (copy), Immutable (copy), Roact (copy)
	local v10 = p4.props.fitAxis or FitChildren.FitAxis.Height
	local v11 = Immutable.RemoveFromDictionary(p4.props, "fitAxis", "maxWidth")
	local width = p4.state.width
	local height = p4.state.height

	if width and height then
		v11 = Immutable.JoinDictionaries(v11, {
			Size = UDim2.new(width, height)
		})
	end

	return Roact.createElement("TextLabel", Immutable.JoinDictionaries(v11, {
		[Roact.Ref] = p4.onRef,
		[Roact.Change.Text] = p4.resize,
		[Roact.Change.TextSize] = p4.resize,
		[Roact.Change.AbsoluteSize] = v10 == FitChildren.FitAxis.Height and p4.resize or nil
	}))
end
function v7.didMount(p5) -- line: 85
	p5.resize(p5.ref)
end

return v7
