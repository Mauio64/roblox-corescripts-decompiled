local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
require(Foundation.Components.Types)

local useBindable = require(Foundation.Utility.useBindable)

local function useCumulativeBackground(p, p2)
	local v = { useBindable(p), (useBindable(p2)) }
	return React.joinBindings(v):map(function(list)
		return {
			Color3 = list[2].Color3:Lerp(list[1].Color3, list[2].Transparency),
			Transparency = 0
		}
	end)
end

return useCumulativeBackground
