local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)

local function wrapDispatchTable(p1) -- line: 26
	-- upvalues: Dash (copy)
	return Dash.map(p1, function(p2) -- line: 27
		return function(...) -- line: 28
			-- upvalues: p2 (copy)
			return p2(...)
		end
	end)
end

return wrapDispatchTable
