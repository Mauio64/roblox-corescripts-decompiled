local ParentParent = script.Parent.Parent
local Element = require(ParentParent.Rhodium).Element
local findFirstInstance = require(ParentParent.TestUtils).findFirstInstance

return function(p1, p2) -- line: 17
	-- upvalues: findFirstInstance (copy), Element (copy)
	local v6 = findFirstInstance(p1, p2)

	if v6 then
		return Element.new("game." .. v6:GetFullName())
	end

	return nil
end
