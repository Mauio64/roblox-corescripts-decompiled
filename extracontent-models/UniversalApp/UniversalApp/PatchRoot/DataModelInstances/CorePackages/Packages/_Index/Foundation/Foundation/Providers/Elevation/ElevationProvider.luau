local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local elevation = require(script.Parent.elevation)
local ElevationLayer = require(Foundation.Enums.ElevationLayer)
local v6 = React.createContext(nil)
local v7 = React.createContext(nil)

return {
	ElevationProvider = function(t1: {[any]: any}) -- line: 24
		-- upvalues: React (copy), ElevationLayer (copy), elevation (copy), v6 (copy)
		local v9 = React.useRef({
			[ElevationLayer.Popover] = 0,
			[ElevationLayer.Drawer] = 0,
			[ElevationLayer.Sheet] = 0,
			[ElevationLayer.Dialog] = 0,
			[ElevationLayer.Notification] = 0
		})
		local v10 = React.useMemo(function() -- line: 33
			-- upvalues: elevation (copy), v9 (copy)
			return {
				acquire = function(p1, t2: {[any]: any}) -- line: 35
					-- upvalues: elevation (copy), v9 (copy)
					local v15 = elevation.ELEVATION_LAYERS[p1]
					local n1 = -1
					local v17 = true
					local v18

					if t2.owner then
						v18 = t2.owner.zIndex + 1
						v17 = t2.owner.zIndex <= v15.finish
					elseif t2.reserve then
						n1 = v9.current[p1] or 0
						v18 = v15.start + (n1 + 1) * v15.step
						v9.current[p1] = n1 + 1
					else
						v18 = v15.start
					end

					if v17 and v18 > v15.finish then
						warn(string.format("Layer '%s' capacity exceeded (%d/%d). Capping zIndex at %d.", tostring(p1), v18, v15.finish, v15.finish))
						v18 = v15.finish
					end

					return {
						layer = p1,
						index = n1,
						zIndex = v18
					}
				end,
				peek = function(p2) -- line: 68
					-- upvalues: v9 (copy)
					return v9.current[p2] or 0
				end,
				releaseIfTop = function(p3, n2: number) -- line: 71
					-- upvalues: v9 (copy)
					local v22 = v9.current[p3] or 0

					if n2 ~= nil and (n2 >= 0 and n2 == v22 - 1) then
						v9.current[p3] = v22 - 1
					end
				end
			}
		end, {})

		return React.createElement(v6.Provider, {
			value = v10
		}, t1.children)
	end,
	ElevationOwnerScope = function(p4) -- line: 86
		-- upvalues: React (copy), v7 (copy)
		return React.createElement(v7.Provider, {
			value = p4.owner
		}, p4.children)
	end,
	useElevationManager = function() -- line: 90
		-- upvalues: React (copy), v6 (copy)
		local v12 = React.useContext(v6)

		if not v12 then
			error("useElevationManager must be used under <ElevationProvider>")
		end

		return v12
	end,
	useOwnerToken = function() -- line: 100
		-- upvalues: React (copy), v7 (copy)
		return (React.useContext(v7))
	end
}
