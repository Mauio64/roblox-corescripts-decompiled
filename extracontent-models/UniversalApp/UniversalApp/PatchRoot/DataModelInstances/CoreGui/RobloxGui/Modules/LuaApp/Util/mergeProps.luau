local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local function mergeProps(p1, p2) -- line: 7
	-- upvalues: Cryo (copy)
	return Cryo.Dictionary.join(p1, p2)
end

return mergeProps
