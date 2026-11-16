local parent = script:FindFirstAncestor("Components").Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Dash = require(parent2.Dash)

local InlineElementType = require(parent.Utils.InlineElementType)
require(parent.Components.InlineLayout.InlineLayoutElements.RenderableInlineElement)
local HardBreakElement = require(parent.Components.InlineLayout.InlineLayoutElements.HardBreakElement)
local isInlineElement = require(parent.Utils.isInlineElement)
local renderInMeasuredFrame = require(parent.Utils.renderInMeasuredFrame)

local InlineSpanElement = {}
InlineSpanElement.__index = InlineSpanElement
InlineSpanElement.__type = InlineElementType

local function getSplitPoint(elements, p: number)
	local total = 0

	for k, item in elements do
		local width = item:getWidth()

		if p < total + width then
			return k, p - total
		end

		total += width
	end

	return -1, -1
end

local function handleSplitTrailingElement(p, p2, value, p3: number, flag: boolean, flag2: boolean?)
	local v = nil

	if flag then
		return v, value
	end

	if value.canForceSplit and flag2 then
		local parts, v2 = value:split(p3, true)
		return parts, v2
	end

	return p, p2
end

function InlineSpanElement.new(wrapperElement, wrapperElementProps, items, value: number?)
	local self = setmetatable({}, InlineSpanElement)
	self.WrapperElement = wrapperElement
	self.wrapperElementProps = wrapperElementProps
	self.Elements = {}
	self.startingIndex = value or 1

	for _, item in items do
		if isInlineElement(item) and item ~= HardBreakElement then
			table.insert(self.Elements, item)
		else
			warn("InlineSpanElement: invalid element provided. Only non inline elements, excluding HardBreakElement, are allowed.")
		end
	end

	if #self.Elements == 0 then
		warn("InlineSpanElement: no elements provided")
	end

	self.canForceSplit = #self.Elements > 0 and self.Elements[#self.Elements].canForceSplit
	return self
end

function InlineSpanElement:getWidth()
	return Dash.sum(Dash.map(self.Elements, function(object)
		return object:getWidth()
	end))
end

function InlineSpanElement:_splitChildAtIndex(p: number, p2: number)
	local parts, v = self.Elements[p]:split(p2, false)

	return parts, v, parts:getWidth() <= p2
end

function InlineSpanElement:split(p: number, flag: boolean?)
	local v = {}
	local v2 = {}

	local splitPoint, v3 = getSplitPoint(self.Elements, p)

	if splitPoint == -1 then
		return self, nil
	end

	local v4 = splitPoint + 1

	local v5, v6, v7 = self:_splitChildAtIndex(splitPoint, v3)

	if not v7 then
		local element = self.Elements[splitPoint]

		if splitPoint > 1 then
			v6 = element
			v5 = nil
		elseif element.canForceSplit and flag then
			v5, v6 = element:split(v3, true)
		end
	end

	if splitPoint > 1 then
		table.move(self.Elements, 1, splitPoint - 1, 1, v)
	end

	if v5 then
		table.insert(v, v5)

		v4 -= 1
	end

	if v6 then
		table.insert(v2, v6)
	end

	if splitPoint < #self.Elements then
		table.move(self.Elements, splitPoint + 1, #self.Elements, #v2 + 1, v2)
	end

	local v8 = InlineSpanElement.new(self.WrapperElement, self.wrapperElementProps, v, self.startingIndex)

	if #v2 > 0 then
		return v8, (InlineSpanElement.new(self.WrapperElement, self.wrapperElementProps, v2, v4))
	end

	return v8, nil
end

function InlineSpanElement:trimStart()
	for k, element in self.Elements do
		local v

		if element.trimStart then
			v = element:trimStart()
		else
			v = element
		end

		if v == element and k == 1 then
			return self
		end

		if v ~= nil then
			local v2 = { v }
			table.move(self.Elements, k + 1, #self.Elements, 2, v2)
			return InlineSpanElement.new(self.WrapperElement, self.wrapperElementProps, v2, self.startingIndex + k - 1)
		end
	end

	return nil
end

function InlineSpanElement:render(id, layoutOrder: number)
	local mapped = Dash.map(self.Elements, function(object, p)
		return renderInMeasuredFrame(object:render(`{id}-{self.startingIndex + p - 1}`, p), object:getWidth(), p)
	end)

	return React.createElement(
		self.WrapperElement,
		Dash.join(self.wrapperElementProps, { id = id, LayoutOrder = layoutOrder }),
		mapped
	)
end

return InlineSpanElement
