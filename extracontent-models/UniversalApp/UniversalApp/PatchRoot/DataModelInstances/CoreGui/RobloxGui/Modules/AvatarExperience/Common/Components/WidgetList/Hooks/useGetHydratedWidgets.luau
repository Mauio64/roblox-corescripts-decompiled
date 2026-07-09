local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)

local React = require(CorePackages.Packages.React)
local getHydratedWidgetItems = require(Modules.AvatarExperience.Common.Components.WidgetList.Utils.getHydratedWidgetItems)

local function useHydratedWidgetItems(p1) -- line: 34
	-- upvalues: React (copy), getHydratedWidgetItems (copy)
	return (React.useMemo(function() -- line: 35
		-- upvalues: getHydratedWidgetItems (copy), p1 (copy)
		return getHydratedWidgetItems(p1)
	end, {
		p1.hydratedWidgetData,
		p1.widgetInfoDetails,
		p1.selectedWidgetIndex
	}))
end

return useHydratedWidgetItems
