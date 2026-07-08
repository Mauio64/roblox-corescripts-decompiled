local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(FoundationParent.React)

local ReactIs = require(FoundationParent.ReactIs)

require(Foundation.Components.Types)

local function indexBindable(p1, s1: string) -- line: 10
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p1) then
		return p1:map(function(p2) -- line: 13
			-- upvalues: s1 (copy)
			return p2[s1]
		end)
	end

	return p1[s1]
end

return indexBindable
