local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent

require(Foundation.Enums.Device)

local React = require(FoundationParent.React)

require(Foundation.Enums.Theme)
require(Foundation.Providers.Style.Tokens)

local StyleSheetRegistry = require(Foundation.StyleSheet.StyleSheetRegistry)

local function useRegistryStyleSheet(p1, p2, n1: number, p3) -- line: 14
	-- upvalues: React (copy), StyleSheetRegistry (copy)
	local v10 = React.useRef({})
	local v11 = React.useMemo(function() -- line: 21
		-- upvalues: StyleSheetRegistry (copy), p1 (copy), p2 (copy), n1 (copy), p3 (copy)
		return StyleSheetRegistry.getStyleSheet(p1, p2, n1, p3)
	end, {
		p1,
		p2,
		n1,
		p3
	})
	local v12 = React.useRef(v11)

	v12.current = v11

	local v13 = React.useCallback(function(p4) -- line: 27
		-- upvalues: v10 (copy), StyleSheetRegistry (copy), v12 (copy)
		for _, v16 in p4 do
			v10.current[v16] = true
		end

		StyleSheetRegistry.addStyleTags(v12.current, p4)
	end, {})

	React.useLayoutEffect(function() -- line: 34
		-- upvalues: v10 (copy), StyleSheetRegistry (copy), v11 (copy)
		local t1 = {}

		for v18 in v10.current do
			table.insert(t1, v18)
		end

		StyleSheetRegistry.addStyleTags(v11, t1)
	end, { v11 })

	return v11, v13
end

return useRegistryStyleSheet
