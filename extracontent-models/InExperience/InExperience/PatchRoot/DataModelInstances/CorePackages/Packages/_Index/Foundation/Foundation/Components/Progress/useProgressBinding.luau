local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

require(parent.React)
local ReactIs = require(parent.ReactIs)

require(Foundation.Components.Types)

local function useProgressBinding(object)
	if ReactIs.isBinding(object) then
		return object:map(function(p: number)
			return (math.clamp(p / 100, 0, 1))
		end), object == nil
	end

	local v

	if object ~= nil then
		v = math.clamp(object / 100, 0, 1)
	end

	return v, object == nil
end

return useProgressBinding
