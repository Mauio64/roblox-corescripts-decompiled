local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)

require(Foundation.Enums.ElevationLayer)

local ElevationProvider = require(script.Parent.ElevationProvider)

require(script.Parent.elevation)

local useElevationManager = ElevationProvider.useElevationManager
local useOwnerToken = ElevationProvider.useOwnerToken

local function useElevation(p1, t1: {[any]: any}) -- line: 20
	-- upvalues: useElevationManager (copy), useOwnerToken (copy), React (copy)
	local v10 = useElevationManager()
	local v11 = useOwnerToken()
	local v12 = React.useMemo(function() -- line: 25
		-- upvalues: v11 (copy), p1 (copy), t1 (copy), v10 (copy)
		local v13 = v11 ~= nil and v11.layer == p1

		if t1.stackAboveOwner then
			if not v11 then
				return v10.acquire(p1, {
					reserve = false
				})
			end

			if v13 then
				return v10.acquire(p1, {
					reserve = true,
					owner = v11
				})
			end

			local v14 = v11.zIndex + 1

			return {
				index = -1,
				layer = p1,
				zIndex = v14
			}
		end

		return v10.acquire(p1, {
			reserve = v13
		})
	end, {
		p1,
		v11,
		v10,
		t1.stackAboveOwner
	})

	React.useEffect(function() -- line: 57
		-- upvalues: v12 (copy), v10 (copy), p1 (copy)
		return function() -- line: 58
			-- upvalues: v12 (copy), v10 (copy), p1 (copy)
			if v12.index ~= nil and v12.index >= 0 then
				v10.releaseIfTop(p1, v12.index)
			end
		end
	end, {
		p1,
		v12.index
	})

	return v12
end

return useElevation
