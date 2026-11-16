local getDeepValue = require(script.Parent.Parent.Dictionary.getDeepValue)

return function(p)
	return function(options)
		return getDeepValue((options or {})[p.layerName] or {}, p.variantName) or false
	end
end
