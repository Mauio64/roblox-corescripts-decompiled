require(script.Parent.AXPagesTypes)

local AXPagesImpl = require(script.Parent.AXPagesImpl)
local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent

require(AvatarExperienceCatalogParent.LuauPolyfill)

local getCatalogV2SearchItemDetails = require(script.Parent.Parent.getCatalogV2SearchItemDetails).getCatalogV2SearchItemDetails

require(AvatarExperienceCatalog.Models.CatalogV2SearchItemDetails)

local function fetchNextPage(p1: ((...any) -> ...any), p2, s1: string) -- line: 21
	-- upvalues: getCatalogV2SearchItemDetails (copy)
	if s1 and s1 ~= "" then
		p2.cursor = s1
	end

	local v9, _ = getCatalogV2SearchItemDetails(p1, p2)
	local v11 = v9:expect()

	return {
		data = v11 and v11.data or {},
		nextPageCursor = v11 and v11.nextPageCursor or nil
	}
end

return {
	new = function(p3: ((...any) -> ...any), p4, t1: {[any]: any}, s2: string?) -- line: 42
		-- upvalues: fetchNextPage (copy), AXPagesImpl (copy)
		local function fetchNextPageWithContext(s3: string) -- line: 49
			-- upvalues: fetchNextPage (copy), p3 (copy), p4 (copy)
			return (fetchNextPage(p3, p4, s3))
		end

		return AXPagesImpl.new(t1, s2, fetchNextPageWithContext)
	end
}
