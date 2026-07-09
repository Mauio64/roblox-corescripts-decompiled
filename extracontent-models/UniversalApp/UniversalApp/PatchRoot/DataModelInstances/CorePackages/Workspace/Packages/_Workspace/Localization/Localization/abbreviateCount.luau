local NumberLocalization = require(script.Parent.NumberLocalization)

return function(p1, p2) -- line: 3
	-- upvalues: NumberLocalization (copy)
	return NumberLocalization.abbreviate(p1, p2)
end
