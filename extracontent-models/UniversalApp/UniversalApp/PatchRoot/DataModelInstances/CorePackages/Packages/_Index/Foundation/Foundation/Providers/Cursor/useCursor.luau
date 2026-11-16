local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local CursorContext = require(script.Parent.CursorContext)
local KeyUtilities = require(script.Parent.KeyUtilities)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)
require(Foundation.Components.Types)
local useTokens = require(Foundation.Providers.Style.useTokens)
local usePresentationContext = PresentationContext.usePresentationContext

local function useCursor(data)
	local v = useTokens()
	local v2 = usePresentationContext()
	local v3

	if v2.colorNamespace then
		v3 = v2.colorNamespace
	else
		v3 = ColorNamespace.Color
	end

	local v4 = React.useContext(CursorContext)
	local refCache = v4.refCache
	local setMountedCursors = v4.setMountedCursors

	local v5 = React.useMemo(function()
		if typeof(data) == "table" then
			return KeyUtilities.encodeKey(v, data.radius, data.offset, data.borderWidth, v3)
		end

		if data == nil then
			return KeyUtilities.encodeKey(v, nil, nil, nil, v3)
		end

		return KeyUtilities.encodeCursorTypeKey(data, v3)
	end, { data, v, v3 })

	React.useEffect(function()
		setMountedCursors(function(p)
			if p[v5] == nil then
				return Dash.join(p, { [v5] = true })
			end

			return p
		end)
	end, { v5 })

	return refCache[v5]
end

return useCursor
