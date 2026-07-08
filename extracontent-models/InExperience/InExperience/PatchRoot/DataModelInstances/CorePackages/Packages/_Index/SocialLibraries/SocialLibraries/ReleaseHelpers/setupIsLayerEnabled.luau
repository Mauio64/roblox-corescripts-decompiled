local getDeepValue = require(script.Parent.Parent.Dictionary.getDeepValue)

return function(t1: {[any]: any}) -- line: 3
	-- upvalues: getDeepValue (copy)
	return function(p1) -- line: 7
		-- upvalues: getDeepValue (copy), t1 (copy)
		local v4 = p1 or {}

		return getDeepValue(v4[t1.layerName] or {}, t1.variantName) or false
	end
end
