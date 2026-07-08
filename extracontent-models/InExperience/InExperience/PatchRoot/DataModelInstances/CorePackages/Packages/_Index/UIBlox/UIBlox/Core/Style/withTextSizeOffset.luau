local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local Roact = require(ParentParent.Parent.Roact)
local StyleConsumer = require(scriptParent.StyleConsumer)

return function(p1) -- line: 9
	-- upvalues: Roact (copy), StyleConsumer (copy)
	assert(type(p1) == "function", "Expect renderCallback to be a function.")

	return Roact.createElement(StyleConsumer, {
		render = function(p2) -- line: 12
			-- upvalues: p1 (copy)
			return p1(p2.derivedValues.textSizeOffset)
		end
	})
end
