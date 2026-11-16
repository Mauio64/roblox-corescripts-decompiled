local parent = script.Parent
local parent2 = parent.Parent.Parent
local Roact = require(parent2.Parent.Roact)
local StyleConsumer = require(parent.StyleConsumer)

return function(callback)
	assert(type(callback) == "function", "Expect renderCallback to be a function.")
	return Roact.createElement(StyleConsumer, {
		render = function(p)
			return callback(p.derivedValues.textSizeOffset)
		end
	})
end
