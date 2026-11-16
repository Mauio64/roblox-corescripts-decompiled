require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceRodux")

local function selectHydratedWidgetData(p2)
	return p2
		and p2.AvatarExperience
		and p2.AvatarExperience.Common
		and p2.AvatarExperience.Common.Widgets
		and p2.AvatarExperience.Common.Widgets.HydratedWidgetData
end

return selectHydratedWidgetData
