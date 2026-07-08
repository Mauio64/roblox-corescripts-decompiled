local Parent = script:FindFirstAncestor("Components").Parent
local ParentParent = Parent.Parent
local React = require(ParentParent.React)
local Dash = require(ParentParent.Dash)
local InlineElementType = require(Parent.Utils.InlineElementType)

require(Parent.Components.InlineLayout.InlineLayoutElements.RenderableInlineElement)

local HardBreakElement = require(Parent.Components.InlineLayout.InlineLayoutElements.HardBreakElement)
local isInlineElement = require(Parent.Utils.isInlineElement)
local t1 = {}

t1.__index = t1
t1.__type = InlineElementType

local function getSplitPoint(t2: {[any]: any}, n1: number) -- line: 20
	local n2 = 0

	for v14, v15 in t2 do
		local v16 = v15:getWidth()

		if n1 < n2 + v16 then
			return v14, n1 - n2
		end

		n2 += v16
	end

	return -1, -1
end
local function handleSplitTrailingElement(p1, p2, p3, n3: number, b1: boolean, b2: boolean?) -- line: 32
	if not b1 then
		if p3.canForceSplit and b2 then
			local v23, v24 = p3:split(n3, true)

			return v23, v24
		end

		return p1, p2
	end

	return nil, p3
end

function t1.new(p4: ((...any) -> ...any), p5, t3: {[any]: any}, n4: number?) -- line: 56
	-- upvalues: t1 (copy), isInlineElement (copy), HardBreakElement (copy)
	local self = setmetatable({}, t1)

	self.WrapperElement = p4
	self.wrapperElementProps = p5
	self.Elements = {}
	self.startingIndex = n4 or 1

	for _, v31 in t3 do
		if not isInlineElement(v31) or v31 == HardBreakElement then
			warn("InlineSpanElement: invalid element provided. Only non inline elements, excluding HardBreakElement, are allowed.")
		else
			table.insert(self.Elements, v31)
		end
	end

	if #self.Elements == 0 then
		warn("InlineSpanElement: no elements provided")
	end

	self.canForceSplit = #self.Elements > 0 and self.Elements[#self.Elements].canForceSplit

	return self
end
function t1.getWidth(p6) -- line: 85
	-- upvalues: Dash (copy)
	return Dash.sum(Dash.map(p6.Elements, function(p7) -- line: 86
		return p7:getWidth()
	end))
end
function t1._splitChildAtIndex(t4: {[any]: any}, n5: number, n6: number) -- line: 91
	local v36, v37 = t4.Elements[n5]:split(n6, false)

	return v36, v37, n6 >= v36:getWidth()
end
function t1.split(t5: {[any]: any}, n7: number, b3: boolean?) -- line: 101
	-- upvalues: getSplitPoint (copy), t1 (copy)
	local t6 = {}
	local t7 = {}
	local v43, v44 = getSplitPoint(t5.Elements, n7)

	if v43 == -1 then
		return t5, nil
	end

	local v45 = v43 + 1
	local v46, v47, v48 = t5:_splitChildAtIndex(v43, v44)

	if not v48 then
		local v49 = t5.Elements[v43]
		local parts = nil

		if not (v43 > 1) then
			if v49.canForceSplit and b3 then
				parts, v47 = v49:split(v44, true)
			else
				parts = v46
			end
		else
			v47 = v49
		end

		v46 = parts
	end

	if v43 > 1 then
		table.move(t5.Elements, 1, v43 - 1, 1, t6)
	end

	if v46 then
		table.insert(t6, v46)
		v45 -= 1
	end

	if v47 then
		table.insert(t7, v47)
	end

	if v43 < #t5.Elements then
		table.move(t5.Elements, v43 + 1, #t5.Elements, #t7 + 1, t7)
	end

	local v51 = t1.new(t5.WrapperElement, t5.wrapperElementProps, t6, t5.startingIndex)

	if #t7 > 0 then
		return v51, (t1.new(t5.WrapperElement, t5.wrapperElementProps, t7, v45))
	end

	return v51, nil
end
function t1.render(t8: {[any]: any}, p8, n8: number) -- line: 147
	-- upvalues: Dash (copy), React (copy)
	local v55 = Dash.map(t8.Elements, function(p9, p10) -- line: 148
		-- upvalues: p8 (copy), t8 (copy)
		return p9:render(`{ p8 }-{ t8.startingIndex + p10 - 1 }`, p10)
	end)

	return React.createElement(t8.WrapperElement, Dash.join(t8.wrapperElementProps, {
		id = p8,
		LayoutOrder = n8
	}), v55)
end

return t1
