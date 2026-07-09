local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local ItemTypeEnum = require(AvatarExperienceCatalogParent.AvatarExperienceCommon).Enums.ItemTypeEnum
local FIntAXLookImpressionDeferTimeoutMs = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FIntAXLookImpressionDeferTimeoutMs
local useStore = require(AvatarExperienceCatalogParent.RoactUtils).Hooks.RoactRodux.useStore

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local selectHydratedLookType = require(AvatarExperienceCatalog.State.Selectors.selectHydratedLookType)

local function useDeferLooksWithoutHydrationFilter(p1) -- line: 48
	-- upvalues: useStore (copy), React (copy), FIntAXLookImpressionDeferTimeoutMs (copy), ItemTypeEnum (copy), selectHydratedLookType (copy)
	local v10 = useStore()
	local v11 = if not p1 then nil else p1.content
	local v12 = React.useRef(false)

	React.useEffect(function() -- line: 54
		-- upvalues: v12 (copy), FIntAXLookImpressionDeferTimeoutMs (copy)
		v12.current = false

		local v13 = math.max(0, FIntAXLookImpressionDeferTimeoutMs) / 1000
		local thread = task.delay(v13, function() -- line: 58
			-- upvalues: v12 (copy)
			v12.current = true
		end)

		return function() -- line: 62
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {})

	return React.useCallback(function(n1: number) -- line: 67
		-- upvalues: v12 (copy), v11 (copy), ItemTypeEnum (copy), selectHydratedLookType (copy), v10 (copy)
		if v12.current then
			return true
		end

		local v16 = v11 and v11[n1] or nil

		if v16 == nil then
			return true
		end

		if v16.type ~= ItemTypeEnum.Look then
			return true
		end

		local id = v16.id

		if id == nil then
			return true
		end

		return selectHydratedLookType(v10:getState(), (tostring(id))) ~= nil
	end, {
		v11,
		v10
	})
end

return useDeferLooksWithoutHydrationFilter
