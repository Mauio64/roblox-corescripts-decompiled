local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
require(parent.React)
local ReactIs = require(parent.ReactIs)

require(Foundation.Components.Types)

local function getBindableValue(object)
	if ReactIs.isBinding(object) then
		return object:getValue()
	end

	return object
end

return getBindableValue
