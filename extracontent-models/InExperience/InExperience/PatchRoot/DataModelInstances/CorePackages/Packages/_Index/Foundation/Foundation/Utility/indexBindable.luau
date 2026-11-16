local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(parent.React)
local ReactIs = require(parent.ReactIs)

require(Foundation.Components.Types)

local function indexBindable(object, p: string)
	if ReactIs.isBinding(object) then
		return object:map(function(p2)
			return p2[p]
		end)
	end

	return object[p]
end

return indexBindable
