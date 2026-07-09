local Parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local t = require(Parent.t)

local function validateInterface(t1: {[any]: any}, t2: {[any]: any}, b1: boolean?) -- line: 11
	-- upvalues: t (copy)
	if b1 == nil then
		b1 = true
	end

	return ((if not b1 then t.strictInterface(t2) else t.interface(t2)))(t1)
end

return validateInterface
