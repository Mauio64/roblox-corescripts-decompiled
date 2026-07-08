local CorePackages = game:GetService("CorePackages")
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local t1 = {
	50,
	128,
	150,
	256,
	512
}

return function(p1) -- line: 15
	-- upvalues: ArgCheck (copy), t1 (copy)
	ArgCheck.isNonNegativeNumber(p1, "Game Icon Size")

	local v5 = #t1

	for _, v in ipairs(t1) do
		if p1 <= v then
			return v
		end
	end

	return t1[v5]
end
