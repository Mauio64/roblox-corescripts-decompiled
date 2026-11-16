local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local React = require(parent.React)

require(parent.AvatarExperienceCommon)

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local ImpressionEnums = AvatarExperienceAnalytics.Enums.ImpressionEnums

local useCatalogPageMonolithDependencies = require(AvatarExperienceCatalog.Providers.useCatalogPageMonolithDependencies)

local function useCatalogSortSeeAllLogging(callback, p)
	local catalogAnalytics = useCatalogPageMonolithDependencies().catalogAnalytics

	local ref = React.useRef(nil)

	local v = React.useCallback(function()
		catalogAnalytics.widgetInteractionV2(p, ImpressionEnums.ActionType.SEE_ALL)

		if callback then
			callback()
		end
	end, { callback, catalogAnalytics, p })

	if callback then
		return ref, v
	end

	return ref, nil
end

return useCatalogSortSeeAllLogging
