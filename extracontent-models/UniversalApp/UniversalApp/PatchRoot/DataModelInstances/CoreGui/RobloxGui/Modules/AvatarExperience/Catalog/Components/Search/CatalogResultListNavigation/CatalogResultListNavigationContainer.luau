local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local CatalogResultListNavigationView = require(script.Parent.CatalogResultListNavigationView)
local useCatalogResultListNavigationViewModel = require(script.Parent.useCatalogResultListNavigationViewModel)

local function CatalogResultListNavigationContainer(p1) -- line: 9
	-- upvalues: useCatalogResultListNavigationViewModel (copy), React (copy), CatalogResultListNavigationView (copy)
	local v7 = useCatalogResultListNavigationViewModel(p1)

	return React.createElement(CatalogResultListNavigationView, v7)
end

return CatalogResultListNavigationContainer
