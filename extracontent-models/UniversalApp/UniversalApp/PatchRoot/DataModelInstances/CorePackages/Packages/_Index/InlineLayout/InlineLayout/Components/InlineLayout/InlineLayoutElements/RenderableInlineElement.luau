local Parent = script:FindFirstAncestor("Components").Parent
local ParentParent = Parent.Parent
local React = require(ParentParent.React)
local Dash = require(ParentParent.Dash)
local InlineElementType = require(Parent.Utils.InlineElementType)
local join = Dash.join
local t1 = {}

t1.__index = t1
t1.__type = InlineElementType

function t1.new(p1, p2, p3) -- line: 44
	-- upvalues: t1 (copy), Dash (copy)
	local self = setmetatable({}, t1)

	self.props = p2
	self.mapProps = p3 or Dash.identity
	self.Element = p1

	return self
end
function t1.getWidth(p4) -- line: 52
	return p4.props.Size.Width.Offset
end
function t1.split(p5) -- line: 56
	-- upvalues: t1 (copy), join (copy)
	return t1.new(p5.Element, join(p5.props))
end
function t1.render(t2: {[any]: any}, s1: string, n1: number) -- line: 60
	-- upvalues: React (copy), Dash (copy)
	return React.createElement(t2.Element, t2.mapProps(Dash.assign(t2.props, {
		id = s1,
		key = tostring(n1),
		LayoutOrder = n1
	})))
end

return t1
