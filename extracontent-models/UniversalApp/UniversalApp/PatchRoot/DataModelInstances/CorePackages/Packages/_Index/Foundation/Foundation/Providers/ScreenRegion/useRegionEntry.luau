local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

require(script.Parent.ScreenRegion)
require(script.Parent.ScreenRegionKind)
local ScreenRegionProvider = require(script.Parent.ScreenRegionProvider)

local ScreenRegionContext = ScreenRegionProvider.ScreenRegionContext

local count = 0

local v = { isVisible = false, isDismissed = false }

local function useRegionEntry(p, data)
	local v2 = React.useContext(ScreenRegionContext)
	local v3 = React.useMemo(function()
		count += 1
		return count
	end, {})
	local state, setState = React.useState(v)

	React.useLayoutEffect(function()
		if v2 == nil or p == nil then
			return nil
		end

		v2.register(p, v3, data.kind, setState)
		return function()
			v2.unregister(p, v3)
		end
	end, { v2, p, v3, data.kind })

	React.useLayoutEffect(function()
		if v2 ~= nil and p ~= nil then
			v2.update(p, v3, {
				isOpen = data.isOpen,
				isMounted = data.isMounted,
				claimKey = data.claimKey,
				priority = data.priority
			})
		end
	end, { v2, p, v3, data.kind, data.isOpen, data.isMounted, data.claimKey, data.priority })

	if v2 == nil or p == nil then
		return { isVisible = data.isOpen, isDismissed = false }
	end

	return state
end

return useRegionEntry
