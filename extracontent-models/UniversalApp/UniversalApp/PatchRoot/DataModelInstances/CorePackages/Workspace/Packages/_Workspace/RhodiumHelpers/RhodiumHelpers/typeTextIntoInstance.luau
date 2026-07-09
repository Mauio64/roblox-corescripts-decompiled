local ParentParent = script.Parent.Parent
local Element = require(ParentParent.Rhodium).Element
local typeTextIntoElement = require(script.Parent.typeTextIntoElement)

return function(p1, p2) -- line: 11
	-- upvalues: Element (copy), typeTextIntoElement (copy)
	local v6 = Element.new(p1)

	typeTextIntoElement(v6, p2)
end
