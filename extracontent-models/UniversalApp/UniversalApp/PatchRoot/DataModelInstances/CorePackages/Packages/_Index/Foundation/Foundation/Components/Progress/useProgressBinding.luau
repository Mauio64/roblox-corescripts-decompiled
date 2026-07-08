local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(FoundationParent.React)

local ReactIs = require(FoundationParent.ReactIs)

require(Foundation.Components.Types)

local function useProgressBinding(p1) -- line: 10
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p1) then
		return p1:map(function(n1: number) -- line: 15
			return (math.clamp(n1 / 100, 0, 1))
		end), p1 == nil
	end

	return if p1 == nil then nil else math.clamp(p1 / 100, 0, 1), p1 == nil
end

return useProgressBinding
