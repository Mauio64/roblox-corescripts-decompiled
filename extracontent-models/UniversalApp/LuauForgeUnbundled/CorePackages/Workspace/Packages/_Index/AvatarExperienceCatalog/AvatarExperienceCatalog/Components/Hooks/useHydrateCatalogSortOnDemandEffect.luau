local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceModel").Enums.ItemTypeEnum
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking

local fFlagAXMigrateAllTabToSduiDev = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXMigrateAllTabToSduiDev

local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useStore

local WidgetConstants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/WidgetConstants")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")

local selectHydratedWidgetData = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Selectors/selectHydratedWidgetData")

local useCatalogPageMonolithDependencies = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Providers/useCatalogPageMonolithDependencies")

local defineFastInt = game:DefineFastInt("AXCarouselMaxItems", 50)

local function getContentToHydrate(p2, p3, p4)
	local contentToHydrate = {}
	local content = p2 and p2.content

	if not content or #content == 0 then
		return contentToHydrate
	end

	local v5 = {}

	for i = 1, math.min(p4 or defineFastInt, #content) do
		local v6 = content[i]
		local kind = v6.type

		local v7 = v5[kind]

		if v7 == nil then
			v7 = if p3 then p3[kind] or false else false
			v5[kind] = v7
		end

		local v8 = v7 and v7[v6.id]

		local v9 = kind == itemTypeEnum.Look and not fFlagAXMigrateAllTabToSduiDev

		if v9 or not v8 then
			table.insert(contentToHydrate, v6)
		end
	end

	return contentToHydrate
end

local function useHydrateCatalogSortOnDemandEffect(p2, p3, p4)
	local fetchHydratedWidgetContent = useCatalogPageMonolithDependencies().fetchHydratedWidgetContent

	local v5 = useNetworking()
	local v6 = useStore()

	local ref = React.useRef(nil)

	React.useEffect(function()
		local id = p2 and p2.id

		if not id or p2.type == WidgetConstants.Types.MySharedAvatarsWidget or ref.current == id then
			return
		end

		local v7

		if p3 and p3.customizedDataMap and p3.customizedDataMap.hydrateOnlyVisibleItems then
			v7 = p4
		end

		local contentToHydrate = getContentToHydrate(p2, selectHydratedWidgetData(v6:getState()), v7)

		if #contentToHydrate == 0 then
			return
		end

		ref.current = id
		fetchHydratedWidgetContent(v5, contentToHydrate, id)
	end, { p2, p3, p4, v5, fetchHydratedWidgetContent, v6 })
end

return useHydrateCatalogSortOnDemandEffect
