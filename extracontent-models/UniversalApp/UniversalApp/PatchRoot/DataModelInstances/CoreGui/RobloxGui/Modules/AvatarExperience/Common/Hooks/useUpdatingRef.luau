local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local function useUpdatingRef(p1) -- line: 13
	-- upvalues: React (copy)
	local v5 = React.useRef(p1)

	v5.current = p1

	return v5
end

return useUpdatingRef
