local Parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

require(Parent.RobloxAppEnums)

local getDeviceType = require(Parent.AppCommonLib).getDeviceType

local function useDeviceType() -- line: 15
	-- upvalues: useSelector (copy), getDeviceType (copy)
	local v5 = useSelector(function(p1) -- line: 16
		return p1.DeviceOrientation
	end)

	return getDeviceType(v5)
end

return useDeviceType
