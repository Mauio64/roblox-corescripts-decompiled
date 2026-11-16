local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)

require(Foundation.Enums.ElevationLayer)

local ElevationProvider = require(script.Parent.ElevationProvider)
require(script.Parent.elevation)

local useElevationManager = ElevationProvider.useElevationManager
local useOwnerToken = ElevationProvider.useOwnerToken

local function useElevation(layer, p)
	local v = useElevationManager()
	local owner = useOwnerToken()

	local v2 = React.useMemo(function()
		local reserve

		if owner == nil then
			reserve = false
		else
			reserve = owner.layer == layer
		end

		if not p.stackAboveOwner then
			return v.acquire(layer, { reserve = reserve })
		end

		if not owner then
			return v.acquire(layer, { reserve = false })
		end

		if reserve then
			return v.acquire(layer, { reserve = true, owner = owner })
		end

		return {
			layer = layer,
			index = -1,
			zIndex = owner.zIndex + 1
		}
	end, { layer, owner, v, p.stackAboveOwner })

	React.useEffect(function()
		return function()
			if v2.index ~= nil and v2.index >= 0 then
				v.releaseIfTop(layer, v2.index)
			end
		end
	end, { layer, v2.index })

	return v2
end

return useElevation
