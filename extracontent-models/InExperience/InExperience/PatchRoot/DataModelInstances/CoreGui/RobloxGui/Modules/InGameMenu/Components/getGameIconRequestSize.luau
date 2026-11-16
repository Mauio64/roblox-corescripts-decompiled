local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)

local v = { 50, 128, 150, 256, 512 }

return function(p)
	ArgCheck.isNonNegativeNumber(p, "Game Icon Size")

	local v2 = #v

	for _, v3 in ipairs(v) do
		if p <= v3 then
			return v3
		end
	end

	return v[v2]
end
