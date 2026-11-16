require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetCatalogV2SearchItemDetails/Types/AXPagesTypes")
local AXPagesImpl = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetCatalogV2SearchItemDetails/Types/AXPagesImpl")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")

local getCatalogV2SearchItemDetails = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Api/GetCatalogV2SearchItemDetails/getCatalogV2SearchItemDetails").getCatalogV2SearchItemDetails

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/CatalogV2SearchItemDetails")

local function fetchNextPage(p2, p3, cursor)
	if cursor and cursor ~= "" then
		p3.cursor = cursor
	end

	local catalogV2SearchItemDetails, v5 = getCatalogV2SearchItemDetails(p2, p3)
	local expect = catalogV2SearchItemDetails:expect()

	return {
		data = expect and expect.data or {},
		nextPageCursor = expect and expect.nextPageCursor or nil
	}
end

return {
	new = function(p2, p3, p4, p5)
		local function fetchNextPageWithContext(p6)
			return fetchNextPage(p2, p3, p6)
		end

		return AXPagesImpl.new(p4, p5, fetchNextPageWithContext)
	end
}
