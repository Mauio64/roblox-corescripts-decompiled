local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local ColorNamespace = require(Foundation.Enums.ColorNamespace)
local CursorContext = require(script.Parent.CursorContext)
local KeyUtilities = require(script.Parent.KeyUtilities)
local PresentationContext = require(Foundation.Providers.Style.PresentationContext)

require(Foundation.Components.Types)

local useTokens = require(Foundation.Providers.Style.useTokens)
local usePresentationContext = PresentationContext.usePresentationContext

local function useCursor(p1) -- line: 17
	-- upvalues: useTokens (copy), usePresentationContext (copy), ColorNamespace (copy), React (copy), CursorContext (copy), KeyUtilities (copy), Dash (copy)
	local v13 = useTokens()
	local v14 = usePresentationContext()
	local v15 = if not v14.colorNamespace then ColorNamespace.Color else v14.colorNamespace
	local v16 = React.useContext(CursorContext)
	local refCache = v16.refCache
	local setMountedCursors = v16.setMountedCursors
	local v19 = React.useMemo(function() -- line: 28
		-- upvalues: p1 (copy), KeyUtilities (copy), v13 (copy), v15 (copy)
		if typeof(p1) == "table" then
			return KeyUtilities.encodeKey(v13, p1.radius, p1.offset, p1.borderWidth, v15)
		end

		if p1 == nil then
			return KeyUtilities.encodeKey(v13, nil, nil, nil, v15)
		end

		return KeyUtilities.encodeCursorTypeKey(p1, v15)
	end, {
		p1,
		v13,
		v15
	})

	React.useEffect(function() -- line: 43
		-- upvalues: setMountedCursors (copy), v19 (copy), Dash (copy)
		setMountedCursors(function(p2) -- line: 44
			-- upvalues: v19 (copy), Dash (copy)
			if p2[v19] == nil then
				return Dash.join(p2, {
					[v19] = true
				})
			end

			return p2
		end)
	end, { v19 })

	return refCache[v19]
end

return useCursor
