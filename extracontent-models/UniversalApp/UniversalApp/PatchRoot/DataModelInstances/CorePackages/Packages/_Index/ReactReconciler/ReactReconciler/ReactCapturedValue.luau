require(script.Parent.ReactInternalTypes)

local ReactFiberComponentStack = require(script.Parent.ReactFiberComponentStack)
local getStackByFiberInDevAndProd = ReactFiberComponentStack.getStackByFiberInDevAndProd

return {
	createCapturedValue = function(p, source)
		return {
			value = p,
			source = source,
			stack = getStackByFiberInDevAndProd(source)
		}
	end
}
