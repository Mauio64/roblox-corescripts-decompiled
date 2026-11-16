local Foundation = script:FindFirstAncestor("Foundation")

local withDefaults = require(Foundation.Utility.withDefaults)

local useInputGroup = require(script.Parent.useInputGroup)

local function useInputGroupDefaults(p, p2)
	return withDefaults(p, withDefaults(useInputGroup(), p2))
end

return useInputGroupDefaults
