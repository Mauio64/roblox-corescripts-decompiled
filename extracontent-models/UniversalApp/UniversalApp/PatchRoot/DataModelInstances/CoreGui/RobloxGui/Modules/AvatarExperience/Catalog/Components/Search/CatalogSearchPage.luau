local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local CatalogSearch = require(Modules.AvatarExperience.Catalog.Components.Search.CatalogSearch)
local OnFocusExperimentExposureLogger = require(Modules.AvatarExperience.Catalog.Components.OnFocusExperimentExposureLogger)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)

return (require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)((withStackVisibilityWrapper((RoactRodux.connect(function(p1, p2) -- line: 40
	return {
		searchParameters = p1.SearchesParameters[p2.detail]
	}
end)(function(p3) -- line: 24
	-- upvalues: Roact (copy), CatalogSearch (copy), OnFocusExperimentExposureLogger (copy)
	local detail = p3.detail
	local searchParameters = p3.searchParameters

	return Roact.createFragment({
		SearchPage = Roact.createElement(CatalogSearch, {
			searchUuid = detail,
			searchParameters = searchParameters
		}),
		OnFocusExperimentExposureLogger = Roact.createElement(OnFocusExperimentExposureLogger, {
			ixpTests = {}
		})
	})
end))))))
