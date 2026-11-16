local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local catalogPageMonolithDependenciesContext = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Providers.CatalogPageMonolithDependenciesContext

local module = require("@luauforge/bundled/gNV")
local module2 = require("@luauforge/bundled/gNU")

local module3 = require("@luauforge/deferred/gPv")
local module4 = require("@luauforge/deferred/gPM")

local module5 = require("@luauforge/bundled/fvF")

local fFlagAXAvatarTabWidgetRecommendation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarTabWidgetRecommendation

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local function CatalogPageMonolithDependenciesProvider(p2)
	local v5 = useDispatch()
	local catalogAnalytics = p2.catalogAnalytics

	local v6 = React.useMemo(function()
		local v7 = {
			catalogAnalytics = catalogAnalytics,
			fetchHydratedWidgetContent = function(p3, p4, p5)
				v5(module(p3, p4, p5))
			end,
			WidgetTileWithImpressionsTagging = module3
		}

		if fFlagAXAvatarTabWidgetRecommendation then
			function v7.fetchWidgetInfo(p3, p4, p5)
				v5(module2(p3, p4, p5))
			end
			v7.CatalogGridWidget = module4
		end

		return v7
	end, { v5, catalogAnalytics })

	return React.createElement(catalogPageMonolithDependenciesContext.Provider, {
		value = v6
	}, p2.children)
end

return roactServices.connect({ catalogAnalytics = module5 })(CatalogPageMonolithDependenciesProvider)
