local parent = script:FindFirstAncestor("SduiCoreSystem").Parent
local t = require(parent.t)

local function validateInterface(p, p2, flag: boolean?)
	local v

	if flag == nil or flag then
		v = t.interface(p2)
	else
		v = t.strictInterface(p2)
	end

	return v(p)
end

return validateInterface
