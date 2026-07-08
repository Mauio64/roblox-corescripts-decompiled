local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(FoundationParent.React)

local ReactIs = require(FoundationParent.ReactIs)

require(Foundation.Components.Types)

local function mapBindable(p1, p2: ((...any) -> ...any)) -- line: 10
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p1) then
		return p1:map(p2)
	end

	return p2(p1)
end

return mapBindable
