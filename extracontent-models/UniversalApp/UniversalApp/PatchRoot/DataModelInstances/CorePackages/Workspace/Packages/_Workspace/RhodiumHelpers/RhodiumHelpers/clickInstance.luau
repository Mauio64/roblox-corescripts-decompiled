local ParentParent = script.Parent.Parent
local Element = require(ParentParent.Rhodium).Element

return function(p1, b1: boolean?) -- line: 7
	-- upvalues: Element (copy)
	local v5 = Element.new(p1)

	if b1 then
		v5:clickWithoutValidation()
	else
		v5:click()
	end

	wait(0)
end
