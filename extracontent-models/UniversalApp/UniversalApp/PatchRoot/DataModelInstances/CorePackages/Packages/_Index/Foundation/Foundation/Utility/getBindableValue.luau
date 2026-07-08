local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(FoundationParent.React)

local ReactIs = require(FoundationParent.ReactIs)

require(Foundation.Components.Types)

local function getBindableValue(p1) -- line: 10
	-- upvalues: ReactIs (copy)
	if ReactIs.isBinding(p1) then
		return p1:getValue()
	end

	return p1
end

return getBindableValue
