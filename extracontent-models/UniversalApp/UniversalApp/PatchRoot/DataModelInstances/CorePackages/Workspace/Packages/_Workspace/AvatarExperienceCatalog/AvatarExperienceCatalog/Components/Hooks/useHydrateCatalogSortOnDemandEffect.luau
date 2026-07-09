local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)
local AvatarExperienceCommon = require(AvatarExperienceCatalogParent.AvatarExperienceCommon)
local ItemTypeEnum = AvatarExperienceCommon.Enums.ItemTypeEnum
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local FFlagAXMigrateAllTabToSduiDev = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXMigrateAllTabToSduiDev
local useStore = require(AvatarExperienceCatalogParent.RoactUtils).Hooks.RoactRodux.useStore
local WidgetConstants = require(AvatarExperienceCatalog.WidgetConstants)

require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local selectHydratedWidgetData = require(AvatarExperienceCatalog.State.Selectors.selectHydratedWidgetData)
local useCatalogPageMonolithDependencies = require(AvatarExperienceCatalog.Providers.useCatalogPageMonolithDependencies)
local v12 = game:DefineFastInt("AXCarouselMaxItems", 50)

local function getContentToHydrate(p1, p2, n1: number?) -- line: 55
	-- upvalues: v12 (copy), ItemTypeEnum (copy), FFlagAXMigrateAllTabToSduiDev (copy)
	local t1 = {}
	local v19 = p1 and p1.content

	if not v19 or #v19 == 0 then
		return t1
	end

	local t2 = {}

	for i = 1, math.min(n1 or v12, #v19) do
		local v22 = v19[i]
		local type = v22.type
		local v24 = t2[type]

		if v24 == nil then
			v24 = not not p2 and (p2[type] or false)
			t2[type] = v24
		end

		local v25 = v24 and v24[v22.id]

		if type == ItemTypeEnum.Look and not FFlagAXMigrateAllTabToSduiDev or not v25 then
			table.insert(t1, v22)
		end
	end

	return t1
end
local function useHydrateCatalogSortOnDemandEffect(p3, p4, n2: number) -- line: 98
	-- upvalues: useCatalogPageMonolithDependencies (copy), useNetworking (copy), useStore (copy), React (copy), WidgetConstants (copy), selectHydratedWidgetData (copy), getContentToHydrate (copy)
	local fetchHydratedWidgetContent = useCatalogPageMonolithDependencies().fetchHydratedWidgetContent
	local v30 = useNetworking()
	local v31 = useStore()
	local v32 = React.useRef(nil)

	React.useEffect(function() -- line: 117
		-- upvalues: p3 (copy), WidgetConstants (copy), v32 (copy), p4 (copy), n2 (copy), selectHydratedWidgetData (copy), v31 (copy), getContentToHydrate (copy), fetchHydratedWidgetContent (copy), v30 (copy)
		local v33 = p3 and p3.id

		if not v33 or p3.type == WidgetConstants.Types.MySharedAvatarsWidget then
			return
		end

		if v33 == v32.current then
			return
		end

		local v34 = nil

		if p4 and p4.customizedDataMap and p4.customizedDataMap.hydrateOnlyVisibleItems then
			v34 = n2
		end

		local v35 = selectHydratedWidgetData(v31:getState())
		local v36 = getContentToHydrate(p3, v35, v34)

		if #v36 == 0 then
			return
		end

		v32.current = v33
		fetchHydratedWidgetContent(v30, v36, v33)
	end, {
		p3,
		p4,
		n2,
		v30,
		fetchHydratedWidgetContent,
		v31
	})
end

return useHydrateCatalogSortOnDemandEffect
