local ParentParent = script.Parent.Parent.Parent.Parent
local Cryo = require(ParentParent.Cryo)
local Roact = require(ParentParent.Roact)
local t = require(ParentParent.t)
local getPageMargin = require(script.Parent.getPageMargin)
local v6 = Roact.Component:extend("PageMargin")

v6.validateProps = t.interface({
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	backgroundColor3 = t.optional(t.Color3),
	backgroundTransparency = t.optional(t.number),
	layoutOrder = t.optional(t.number),
	size = t.optional(t.UDim2),
	useAutomaticSizing = t.optional(t.boolean),
	zIndex = t.optional(t.number)
})
v6.defaultProps = {
	backgroundTransparency = 0,
	layoutOrder = 0,
	useAutomaticSizing = false,
	anchorPoint = Vector2.new(0, 0),
	position = UDim2.new(),
	size = UDim2.fromScale(1, 1)
}

function v6.init(p1) -- line: 41
	-- upvalues: Roact (copy), getPageMargin (copy)
	p1.state = {}
	p1.ref = Roact.createRef()

	function p1.onResize(p2) -- line: 44
		-- upvalues: p1 (copy), getPageMargin (copy)
		if p1.mounted then
			local AbsoluteSizeX = p2.AbsoluteSize.X

			p1:setState(function(p3) -- line: 47
				-- upvalues: getPageMargin (copy), AbsoluteSizeX (copy)
				local v14 = getPageMargin(AbsoluteSizeX)

				if v14 ~= p3.margin then
					return {
						margin = v14
					}
				end

				return nil
			end)
		end
	end
end
function v6.render(p4) -- line: 61
	-- upvalues: Roact (copy), Cryo (copy)
	return Roact.createElement("Frame", {
		AnchorPoint = p4.props.anchorPoint,
		AutomaticSize = p4.props.useAutomaticSizing and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
		BackgroundColor3 = p4.props.backgroundColor3,
		BackgroundTransparency = p4.props.backgroundTransparency,
		BorderSizePixel = 0,
		Position = p4.props.position,
		Size = p4.props.size,
		[Roact.Change.AbsoluteSize] = p4.onResize,
		[Roact.Ref] = p4.ref,
		LayoutOrder = p4.props.layoutOrder,
		ZIndex = p4.props.zIndex
	}, Cryo.Dictionary.join(p4.props[Roact.Children], {
		padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, p4.state.margin),
			PaddingRight = UDim.new(0, p4.state.margin)
		})
	}))
end
function v6.didMount(p5) -- line: 86
	p5.mounted = true

	if p5.ref.current then
		p5.onResize(p5.ref.current)
	end
end
function v6.willUnmount(p6) -- line: 93
	p6.mounted = false
end

return v6
