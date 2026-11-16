local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

require(Foundation.Components.Types)

local function useBindable(p)
	local v, v2 = React.useBinding(nil)

	if ReactIs.isBinding(p) then
		return p
	end

	v2(p)
	return v
end

return useBindable
