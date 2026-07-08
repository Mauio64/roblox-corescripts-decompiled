local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Components.Types)

local useBindable = require(Foundation.Utility.useBindable)

local function useCumulativeBackground(p1, p2) -- line: 11
	-- upvalues: useBindable (copy), React (copy)
	local v8 = useBindable(p1)
	local v9 = useBindable(p2)

	return React.joinBindings({
		v8,
		v9
	}):map(function(p3) -- line: 18
		return {
			Transparency = 0,
			Color3 = p3[2].Color3:Lerp(p3[1].Color3, p3[2].Transparency)
		}
	end)
end

return useCumulativeBackground
