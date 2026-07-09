local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local useSignalState = require(AvatarExperienceCatalogParent.SignalsReact).useSignalState
local getBreakpointFromRowWidth = require(AvatarExperienceCatalog.Utils.getBreakpointFromRowWidth)
local getUIScaleFromTokens = require(AvatarExperienceCatalog.Utils.getUIScaleFromTokens)
local useTokens = require(AvatarExperienceCatalogParent.Foundation).Hooks.useTokens

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum)

local GetAXMarketplaceWidgetStore = require(AvatarExperienceCatalog.Stores.GetAXMarketplaceWidgetStore)

local function useCatalogFeedBreakpoint(n1: number?) -- line: 21
	-- upvalues: useTokens (copy), getUIScaleFromTokens (copy), GetAXMarketplaceWidgetStore (copy), useSignalState (copy), React (copy), getBreakpointFromRowWidth (copy)
	local v11 = useTokens()
	local v12 = getUIScaleFromTokens(v11)
	local v13 = n1 == nil and 0.2 or n1
	local v14 = GetAXMarketplaceWidgetStore(false)
	local v15 = useSignalState(v14.getScreenSize)
	local v16, v17 = React.useState(nil)
	local v18 = React.useRef(nil)

	React.useEffect(function() -- line: 44
		-- upvalues: v18 (copy)
		return function() -- line: 45
			-- upvalues: v18 (copy)
			if v18.current then
				task.cancel(v18.current)
				v18.current = nil
			end
		end
	end, {})

	local v19 = React.useCallback(function(p1) -- line: 53
		-- upvalues: getBreakpointFromRowWidth (copy), v12 (copy), v18 (copy), v13 (copy), v17 (copy)
		local AbsoluteSizeX = p1.AbsoluteSize.X
		local v22 = getBreakpointFromRowWidth(AbsoluteSizeX, v12)

		if v18.current then
			task.cancel(v18.current)
		end

		v18.current = task.delay(v13, function() -- line: 59
			-- upvalues: v18 (copy), v17 (copy), v22 (copy)
			v18.current = nil
			v17(v22)
		end)
	end, {
		v12,
		v13
	})

	return if v16 == nil then v15 else v16, v19
end

return useCatalogFeedBreakpoint
