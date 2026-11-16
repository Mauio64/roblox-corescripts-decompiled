local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
require(parent.React)
local ReactIs = require(parent.ReactIs)

require(Foundation.Components.Types)

local function mapBindable(object, callback)
	if ReactIs.isBinding(object) then
		return object:map(callback)
	end

	return callback(object)
end

return mapBindable
