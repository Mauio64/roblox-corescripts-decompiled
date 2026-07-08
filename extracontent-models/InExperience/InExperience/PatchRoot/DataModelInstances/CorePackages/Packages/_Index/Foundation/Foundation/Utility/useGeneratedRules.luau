local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Enums.Device)
require(Foundation.Enums.Theme)

local getGeneratedRules = require(Foundation.Utility.getGeneratedRules)

local function useGeneratedRules(p1, p2) -- line: 11
	-- upvalues: React (copy), getGeneratedRules (copy)
	return React.useMemo(function() -- line: 12
		-- upvalues: getGeneratedRules (copy), p1 (copy), p2 (copy)
		return getGeneratedRules(p1, p2)
	end, {
		p1,
		p2
	})
end

return useGeneratedRules
