local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local useNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Hooks.useNetworking
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/RoactUtils").Hooks.RoactRodux.useStore
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/ResultsList/WidgetListInfoViewModel")
local selectHydratedWidgetData = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/State/Selectors/selectHydratedWidgetData")
local getCatalogContentToHydrate = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Utils/getCatalogContentToHydrate")
local useCatalogPageMonolithDependencies = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Providers/useCatalogPageMonolithDependencies")

local v5 = {}

local function useHydrateCatalogItemGridOnDemandEffect(current, p2)
	local fetchHydratedWidgetContent = useCatalogPageMonolithDependencies().fetchHydratedWidgetContent

	local v6 = useNetworking()
	local v7 = useStore()

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	React.useEffect(function()
		if not current or current == "" then
			return
		end

		local v8 = p2 or v5

		if ref.current == current and ref2.current == v8 then
			return
		end

		local v10 = getCatalogContentToHydrate(v8, selectHydratedWidgetData(v7:getState()), nil)

		ref.current = current
		ref2.current = v8

		if #v10 == 0 then
			return
		end

		fetchHydratedWidgetContent(v6, v10, current)
	end, { current, p2, v6, fetchHydratedWidgetContent, v7 })
end

return useHydrateCatalogItemGridOnDemandEffect
