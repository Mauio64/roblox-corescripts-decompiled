local InlineLayout = script:FindFirstAncestor("InlineLayout")
local parent = InlineLayout.Parent

local React = require(parent.React)
local InlineElementType = require(InlineLayout.Utils.InlineElementType)

local class = {}
class.__index = class
class.__type = InlineElementType

function class.new(width: number, canForceSplit: boolean?)
	local self = setmetatable({}, class)
	self.width = width
	self.canForceSplit = canForceSplit
	return self
end

function class.getWidth(p)
	return p.width
end

function class.split(p, _: number, _: boolean?)
	return class.new(p.width, p.canForceSplit)
end

function class.render(p, p2, layoutOrder: number)
	return React.createElement("TextLabel", {
		key = tostring(layoutOrder),
		LayoutOrder = layoutOrder,
		Size = UDim2.fromOffset(p.width, 20),
		Text = `{p2}`
	})
end

local class2 = {}
class2.__index = class2
class2.__type = InlineElementType

function class2.new(width: number, canForceSplit: boolean?)
	local self = setmetatable({}, class2)
	self.width = width
	self.canForceSplit = canForceSplit
	return self
end

function class2.getWidth(p)
	return p.width
end

function class2.split(p, p2: number, flag: boolean?)
	local v = math.floor(p.width / 2)

	local v2 = p.width - v

	if flag and p2 < v then
		v2 = p.width - p2
	else
		p2 = v
	end

	return class2.new(p2, p.canForceSplit), (class2.new(v2, p.canForceSplit))
end

function class2.render(p, p2, layoutOrder: number)
	return React.createElement("TextLabel", {
		key = tostring(layoutOrder),
		LayoutOrder = layoutOrder,
		Size = UDim2.fromOffset(p.width, 20),
		Text = `{p2}`
	})
end

return { MockInlineElement = class, SplittableMockInlineElement = class2 }
