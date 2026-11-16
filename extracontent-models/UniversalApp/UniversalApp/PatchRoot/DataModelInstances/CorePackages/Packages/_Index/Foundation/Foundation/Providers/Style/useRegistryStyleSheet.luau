local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
require(Foundation.Enums.ColorMode)
require(Foundation.Enums.Device)
local React = require(parent.React)
require(Foundation.Enums.ThemeName)
require(Foundation.Providers.Style.Tokens)

local StyleSheetRegistry = require(Foundation.StyleSheet.StyleSheetRegistry)

local function useRegistryStyleSheet(p, p2, p3, p4: number, p5)
	local ref = React.useRef({})

	local current = React.useMemo(function()
		return StyleSheetRegistry.resolveStyleSheet(p2, p3, p4, p5, p)
	end, { p, p2, p3, p4, p5 })
	local ref2 = React.useRef(current)
	ref2.current = current

	local v = React.useCallback(function(items)
		for _, item in items do
			ref.current[item] = true
		end

		StyleSheetRegistry.addStyleTags(ref2.current, items)
	end, {})

	React.useLayoutEffect(function()
		local v2 = {}

		for k in ref.current do
			table.insert(v2, k)
		end

		StyleSheetRegistry.addStyleTags(current, v2)

		StyleSheetRegistry.acquireStyleSheet(current)
		return function()
			StyleSheetRegistry.releaseStyleSheet(current)
		end
	end, { current })

	return current, v
end

return useRegistryStyleSheet
