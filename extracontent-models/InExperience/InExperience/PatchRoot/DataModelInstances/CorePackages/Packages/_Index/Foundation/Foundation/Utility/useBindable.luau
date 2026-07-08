local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactIs = require(FoundationParent.ReactIs)

require(Foundation.Components.Types)

local function useBindable(p1) -- line: 10
	-- upvalues: React (copy), ReactIs (copy)
	local v7, v8 = React.useBinding(nil)

	if ReactIs.isBinding(p1) then
		return p1
	end

	v8(p1)

	return v7
end

return useBindable
