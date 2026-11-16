local CorePackages = game:GetService("CorePackages")

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/deferred/gUf")

local function useHydratedWidgetItems(data)
	return (React.useMemo(function()
		return module(data)
	end, { data.hydratedWidgetData, data.widgetInfoDetails, data.selectedWidgetIndex }))
end

return useHydratedWidgetItems
