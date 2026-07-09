local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local CatalogPageMonolithDependenciesContext = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog).Providers.CatalogPageMonolithDependenciesContext
local FetchHydratedWidgetContent = require(Modules.AvatarExperience.Catalog.Thunks.FetchHydratedWidgetContent)
local WidgetTileWithImpressionsTagging = require(Modules.AvatarExperience.Common.Components.Widgets.WidgetTileWithImpressionsTagging)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch

local function CatalogPageMonolithDependenciesProvider(t1: {[any]: any}) -- line: 45
	-- upvalues: useDispatch (copy), React (copy), FetchHydratedWidgetContent (copy), WidgetTileWithImpressionsTagging (copy), CatalogPageMonolithDependenciesContext (copy)
	local v13 = useDispatch()
	local catalogAnalytics = t1.catalogAnalytics
	local v15 = React.useMemo(function() -- line: 49
		-- upvalues: catalogAnalytics (copy), v13 (copy), FetchHydratedWidgetContent (copy), WidgetTileWithImpressionsTagging (copy)
		return {
			catalogAnalytics = catalogAnalytics,
			fetchHydratedWidgetContent = function(p1, p2, p3) -- line: 52
				-- upvalues: v13 (copy), FetchHydratedWidgetContent (copy)
				v13(FetchHydratedWidgetContent(p1, p2, p3))
			end,
			WidgetTileWithImpressionsTagging = WidgetTileWithImpressionsTagging
		}
	end, {
		v13,
		catalogAnalytics
	})

	return React.createElement(CatalogPageMonolithDependenciesContext.Provider, {
		value = v15
	}, t1.children)
end

return RoactServices.connect({
	catalogAnalytics = Analytics
})(CatalogPageMonolithDependenciesProvider)
