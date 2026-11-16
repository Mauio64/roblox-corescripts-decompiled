local parent = script:FindFirstAncestor("Navigation").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagOptionalNavigation = SharedFlags.FFlagOptionalNavigation

local useNavigation = require(script.Parent.useNavigation)

local function useRouteName()
	local v = useNavigation()

	if FFlagOptionalNavigation and v == nil then
		return nil
	end

	return v.state.routeName
end

return useRouteName
