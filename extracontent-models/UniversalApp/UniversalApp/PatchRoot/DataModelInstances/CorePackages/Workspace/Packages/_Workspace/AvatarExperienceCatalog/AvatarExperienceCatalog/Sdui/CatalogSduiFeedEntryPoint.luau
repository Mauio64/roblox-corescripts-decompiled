local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)

require(AvatarExperienceCatalogParent.Foundation)

local CatalogSduiEntryPoint = require(script.Parent.CatalogSduiEntryPoint)
local getCatalogPageIdentifier = require(script.Parent.Utils.getCatalogPageIdentifier)
local MarketplaceFeedSkeleton = require(AvatarExperienceCatalog.Components.MarketplaceFeedSkeleton.MarketplaceFeedSkeleton)
local FFlagAXMarketplaceLoadingSkeleton = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXMarketplaceLoadingSkeleton

local function CatalogSduiFeedEntryPoint(t1: {[any]: any}, p1) -- line: 26
	-- upvalues: FFlagAXMarketplaceLoadingSkeleton (copy), React (copy), MarketplaceFeedSkeleton (copy), CatalogSduiEntryPoint (copy), getCatalogPageIdentifier (copy)
	local v11 = if not FFlagAXMarketplaceLoadingSkeleton then nil else React.createElement(MarketplaceFeedSkeleton)

	return React.createElement(CatalogSduiEntryPoint, {
		context = t1.context,
		identifier = getCatalogPageIdentifier(t1.context),
		Size = t1.Size,
		AutomaticSize = t1.AutomaticSize,
		Position = t1.Position,
		loadingSlot = v11,
		ref = p1
	})
end

return React.forwardRef(CatalogSduiFeedEntryPoint)
