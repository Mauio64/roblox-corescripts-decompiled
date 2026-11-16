local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

require(parent.AvatarExperienceRodux)

local function selectHydratedWidgetData(p)
	return p
		and p.AvatarExperience
		and p.AvatarExperience.Common
		and p.AvatarExperience.Common.Widgets
		and p.AvatarExperience.Common.Widgets.HydratedWidgetData
end

return selectHydratedWidgetData
