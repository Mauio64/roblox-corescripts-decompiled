local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

require(Parent.AvatarExperienceRodux)

local function selectHydratedWidgetData(p1) -- line: 17
	return p1 and (p1.AvatarExperience and (p1.AvatarExperience.Common and (p1.AvatarExperience.Common.Widgets and p1.AvatarExperience.Common.Widgets.HydratedWidgetData)))
end

return selectHydratedWidgetData
