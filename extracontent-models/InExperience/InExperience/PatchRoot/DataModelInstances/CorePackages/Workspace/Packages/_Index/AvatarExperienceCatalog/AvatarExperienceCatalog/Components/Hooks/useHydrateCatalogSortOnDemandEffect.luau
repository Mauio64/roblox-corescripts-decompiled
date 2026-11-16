local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev

local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore

local WidgetConstants = require(AvatarExperienceCatalog.WidgetConstants)
require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local selectHydratedWidgetData = require(AvatarExperienceCatalog.State.Selectors.selectHydratedWidgetData)

local useCatalogPageMonolithDependencies = require(AvatarExperienceCatalog.Providers.useCatalogPageMonolithDependencies)

local defineFastInt = game:DefineFastInt("AXCarouselMaxItems", 50)

local function getContentToHydrate(p, p2, p3: number?)
	local contentToHydrate = {}
	local content = p and p.content

	if not content or #content == 0 then
		return contentToHydrate
	end

	local v = {}

	for i = 1, math.min(p3 or defineFastInt, #content) do
		local v2 = content[i]
		local kind = v2.type

		local v3 = v[kind]

		if v3 == nil then
			if p2 then
				v3 = p2[kind] or false
			else
				v3 = false
			end

			v[kind] = v3
		end

		local v4 = v3 and v3[v2.id]
		local v5

		if kind == ItemTypeEnum.Look then
			v5 = not FFlagAXMigrateAllTabToSduiDev
		else
			v5 = false
		end

		if v5 or not v4 then
			table.insert(contentToHydrate, v2)
		end
	end

	return contentToHydrate
end

local function useHydrateCatalogSortOnDemandEffect(p, p2, p3: number)
	local fetchHydratedWidgetContent = useCatalogPageMonolithDependencies().fetchHydratedWidgetContent

	local v = useNetworking()
	local v2 = useStore()

	local ref = React.useRef(nil)

	React.useEffect(function()
		local id = p and p.id

		if not id or p.type == WidgetConstants.Types.MySharedAvatarsWidget or ref.current == id then
			return
		end

		local v3

		if p2 and p2.customizedDataMap and p2.customizedDataMap.hydrateOnlyVisibleItems then
			v3 = p3
		end

		local contentToHydrate = getContentToHydrate(p, selectHydratedWidgetData(v2:getState()), v3)

		if #contentToHydrate == 0 then
			return
		end

		ref.current = id
		fetchHydratedWidgetContent(v, contentToHydrate, id)
	end, { p, p2, p3, v, fetchHydratedWidgetContent, v2 })
end

return useHydrateCatalogSortOnDemandEffect
