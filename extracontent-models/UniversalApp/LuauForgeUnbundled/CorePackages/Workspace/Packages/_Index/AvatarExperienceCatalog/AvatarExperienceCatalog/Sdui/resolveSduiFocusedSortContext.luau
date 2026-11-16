local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppCommonLib").Logging

local function resolveSduiFocusedSortContext(data)
	local selectedCategoryId = data.selectedCategoryId

	if not selectedCategoryId then
		logging.warn("resolveSduiFocusedSortContext: nil selectedCategoryId at click time " .. "(sortId=" .. tostring(data.sortId) .. ", route=" .. tostring(data.routeName) .. "); SDUI See All handoff aborted before context lookup.")

		return nil
	end

	local contextForWidgetsById = data.getContextForWidgetsById(
		data.routeName,
		selectedCategoryId,
		data.selectedSubcategoryId
	)

	if contextForWidgetsById then
		return contextForWidgetsById
	end

	logging.warn("resolveSduiFocusedSortContext: getContextForWidgetsById returned nil " .. "(sortId=" .. tostring(data.sortId) .. ", route=" .. tostring(data.routeName) .. ", categoryId=" .. tostring(selectedCategoryId) .. ", subcategoryId=" .. tostring(data.selectedSubcategoryId) .. "); SDUI See All handoff aborted because the reader-aligned ContextWidgetInfo key could not be built.")

	return nil
end

return resolveSduiFocusedSortContext
