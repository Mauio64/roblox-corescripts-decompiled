local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)

local elevation = require(script.Parent.elevation)

local ElevationLayer = require(Foundation.Enums.ElevationLayer)

local context = React.createContext(nil)
local context2 = React.createContext(nil)
local ElevationProvider = {}

function ElevationProvider.ElevationProvider(p)
	local v = React.useRef({
		[ElevationLayer.Popover] = 0,
		[ElevationLayer.Floating] = 0,
		[ElevationLayer.Drawer] = 0,
		[ElevationLayer.Sheet] = 0,
		[ElevationLayer.Dialog] = 0,
		[ElevationLayer.Notification] = 0
	})

	local v2 = React.useMemo(function()
		return {
			acquire = function(layer, p2)
				local v2 = elevation.ELEVATION_LAYERS[layer]
				local v3 = -1

				local v4 = true
				local zIndex

				if p2.owner then
					zIndex = p2.owner.zIndex + 1
					v4 = p2.owner.zIndex <= v2.finish
				elseif p2.reserve then
					v3 = v.current[layer] or 0
					zIndex = v2.start + (v3 + 1) * v2.step
					v.current[layer] = v3 + 1
				else
					zIndex = v2.start
				end

				if v4 and v2.finish < zIndex then
					warn(string.format(
						"Layer '%s' capacity exceeded (%d/%d). Capping zIndex at %d.",
						tostring(layer),
						zIndex,
						v2.finish,
						v2.finish
					))

					zIndex = v2.finish
				end

				return { layer = layer, index = v3, zIndex = zIndex }
			end,
			peek = function(p2)
				return v.current[p2] or 0
			end,
			releaseIfTop = function(p2, p3: number)
				local v2 = v.current[p2] or 0

				if p3 ~= nil and p3 >= 0 and p3 == v2 - 1 then
					v.current[p2] = v2 - 1
				end
			end
		}
	end, {})

	return React.createElement(context.Provider, { value = v2 }, p.children)
end

function ElevationProvider.ElevationOwnerScope(p)
	return React.createElement(context2.Provider, { value = p.owner }, p.children)
end

function ElevationProvider.useElevationManager()
	local v = React.useContext(context)

	if not v then
		error("useElevationManager must be used under <ElevationProvider>")
	end

	return v
end

function ElevationProvider.useOwnerToken()
	return (React.useContext(context2))
end

return ElevationProvider
