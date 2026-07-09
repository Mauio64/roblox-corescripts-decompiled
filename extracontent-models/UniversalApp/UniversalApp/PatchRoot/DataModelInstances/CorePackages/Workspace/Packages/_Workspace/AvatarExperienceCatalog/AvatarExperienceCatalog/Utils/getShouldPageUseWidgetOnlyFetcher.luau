local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local v2 = require(Parent.AvatarExperienceCommon).Enums.CatalogCategories.Recommended:rawValue()

local function getShouldPageUseWidgetOnlyFetcher(p1, n1: number?, s1: string?) -- line: 25
	-- upvalues: v2 (copy)
	if not p1 then
		return false
	end

	if s1 then
		return false
	end

	if p1.Id ~= v2 then
		return false
	end

	if n1 and n1 > 0 then
		return false
	end

	return true
end

return getShouldPageUseWidgetOnlyFetcher
