local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent

require(AvatarExperienceCatalogParent.AvatarExperienceRodux)
require(AvatarExperienceCatalog.Components.ResultsList.WidgetListInfoViewModel)

local function buildHydrationReduxPayload(t1: {[any]: any}, t2: {[any]: any}) -- line: 18
	local t3 = {}

	for _, v8 in t1 do
		local type = v8.type
		local str = tostring(v8.id)

		if not t3[type] then
			t3[type] = {}
		end

		local v11 = table.clone(v8)

		v11.id = str
		t3[type][str] = v11
	end

	for _, v13 in t2 do
		local type = v13.type
		local str = tostring(v13.id)

		if not t3[type] then
			t3[type] = {}
		end

		if not t3[type][str] then
			t3[type][str] = {
				failedToHydrate = true,
				id = str,
				type = type
			}
		end
	end

	return t3
end

return buildHydrationReduxPayload
