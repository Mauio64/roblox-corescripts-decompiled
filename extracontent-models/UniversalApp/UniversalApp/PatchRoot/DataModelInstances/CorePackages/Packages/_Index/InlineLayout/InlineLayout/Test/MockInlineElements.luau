local InlineLayout = script:FindFirstAncestor("InlineLayout")
local InlineLayoutParent = InlineLayout.Parent
local React = require(InlineLayoutParent.React)
local InlineElementType = require(InlineLayout.Utils.InlineElementType)
local t1 = {}

t1.__index = t1
t1.__type = InlineElementType

function t1.new(n1: number, b1: boolean?) -- line: 12
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.width = n1
	self.canForceSplit = b1

	return self
end
function t1.getWidth(p1) -- line: 19
	return p1.width
end
function t1.split(t2: {[any]: any}, _: number, _: boolean?) -- line: 23
	-- upvalues: t1 (copy)
	return t1.new(t2.width, t2.canForceSplit)
end
function t1.render(t3: {[any]: any}, p2, n3: number) -- line: 28
	-- upvalues: React (copy)
	return React.createElement("TextLabel", {
		key = tostring(n3),
		LayoutOrder = n3,
		Size = UDim2.new(0, t3.width, 0, 20),
		Text = `{ p2 }`
	})
end

local t4 = {}

t4.__index = t4
t4.__type = InlineElementType

function t4.new(n4: number, b3: boolean?) -- line: 42
	-- upvalues: t4 (copy)
	local self = setmetatable({}, t4)

	self.width = n4
	self.canForceSplit = b3

	return self
end
function t4.getWidth(p3) -- line: 49
	return p3.width
end
function t4.split(t5: {[any]: any}, n5: number, b4: boolean?) -- line: 53
	-- upvalues: t4 (copy)
	local v24 = math.floor(t5.width / 2)
	local v25 = t5.width - v24

	if b4 and n5 < v24 then
		v24 = n5
		v25 = t5.width - n5
	end

	return t4.new(v24, t5.canForceSplit), (t4.new(v25, t5.canForceSplit))
end
function t4.render(t6: {[any]: any}, p4, n6: number) -- line: 70
	-- upvalues: React (copy)
	return React.createElement("TextLabel", {
		key = tostring(n6),
		LayoutOrder = n6,
		Size = UDim2.new(0, t6.width, 0, 20),
		Text = `{ p4 }`
	})
end

return {
	MockInlineElement = t1,
	SplittableMockInlineElement = t4
}
