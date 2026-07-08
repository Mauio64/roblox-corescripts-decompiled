require(script.Parent.ReactInternalTypes)

local getStackByFiberInDevAndProd = require(script.Parent.ReactFiberComponentStack).getStackByFiberInDevAndProd

return {
	createCapturedValue = function(p1, p2) -- line: 26
		-- upvalues: getStackByFiberInDevAndProd (copy)
		return {
			value = p1,
			source = p2,
			stack = getStackByFiberInDevAndProd(p2)
		}
	end
}
