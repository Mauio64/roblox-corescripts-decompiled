require(script.Parent.AXPagesTypes)
local AXPagesImpl = require(script.Parent.AXPagesImpl)

local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
require(parent.LuauPolyfill)

local getCatalogV2SearchItemDetails = require(script.Parent.Parent.getCatalogV2SearchItemDetails)
local getCatalogV2SearchItemDetails2 = getCatalogV2SearchItemDetails.getCatalogV2SearchItemDetails

require(AvatarExperienceCatalog.Models.CatalogV2SearchItemDetails)

local function fetchNextPage(callback, p, cursor: string)
	if cursor and cursor ~= "" then
		p.cursor = cursor
	end

	local catalogV2SearchItemDetails, _ = getCatalogV2SearchItemDetails2(callback, p)
	local expect = catalogV2SearchItemDetails:expect()

	return {
		data = expect and expect.data or {},
		nextPageCursor = expect and expect.nextPageCursor or nil
	}
end

return {
	new = function(callback, p, p2, p3: string?)
		local function fetchNextPageWithContext(cursor: string)
			return fetchNextPage(callback, p, cursor)
		end

		return AXPagesImpl.new(p2, p3, fetchNextPageWithContext)
	end
}
