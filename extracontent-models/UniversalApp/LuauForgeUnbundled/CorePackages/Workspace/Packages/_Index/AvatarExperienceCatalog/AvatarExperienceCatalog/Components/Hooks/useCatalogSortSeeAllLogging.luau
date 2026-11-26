local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")

local impressionEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics").Enums.ImpressionEnums

local useCatalogPageMonolithDependencies = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Providers/useCatalogPageMonolithDependencies")

local function useCatalogSortSeeAllLogging(callback, p2)
	local catalogAnalytics = useCatalogPageMonolithDependencies().catalogAnalytics

	local ref = React.useRef(nil)

	local v5 = React.useCallback(function()
		catalogAnalytics.widgetInteractionV2(p2, impressionEnums.ActionType.SEE_ALL)

		if callback then
			callback()
		end
	end, { callback, catalogAnalytics, p2 })

	if callback then
		return ref, v5
	end

	return ref, nil
end

return useCatalogSortSeeAllLogging
