local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore
require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)
local selectHydratedWidgetData = require(AvatarExperienceCatalog.State.Selectors.selectHydratedWidgetData)
local getCatalogContentToHydrate = require(AvatarExperienceCatalog.Utils.getCatalogContentToHydrate)
local useCatalogPageMonolithDependencies = require(AvatarExperienceCatalog.Providers.useCatalogPageMonolithDependencies)

local v = {}

local function useHydrateCatalogItemGridOnDemandEffect(current: string?, p)
	local fetchHydratedWidgetContent = useCatalogPageMonolithDependencies().fetchHydratedWidgetContent

	local v2 = useNetworking()
	local v3 = useStore()

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	React.useEffect(function()
		if not current or current == "" then
			return
		end

		local current2 = p or v

		if ref.current == current and ref2.current == current2 then
			return
		end

		local catalogContentToHydrate = getCatalogContentToHydrate(
			current2,
			selectHydratedWidgetData(v3:getState()),
			nil
		)

		ref.current = current
		ref2.current = current2

		if #catalogContentToHydrate == 0 then
			return
		end

		fetchHydratedWidgetContent(v2, catalogContentToHydrate, current)
	end, { current, p, v2, fetchHydratedWidgetContent, v3 })
end

return useHydrateCatalogItemGridOnDemandEffect
